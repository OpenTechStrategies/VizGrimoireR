## Copyright (C) 2012, 2013 Bitergia
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
##
## This file is a part of the vizGrimoire.R package
##
## Authors:
##   Jesus M. Gonzalez-Barahona <jgb@bitergia.com>
##   Alvaro del Castillo San Felix <acs@bitergia.com>
##   Daniel Izquierdo Cortazar <dizquierdo@bitergia.com>
##
##
## Usage:
##  R --no-restore --no-save < mls-milestone0.R
## or
##  R CMD BATCH mls-milestone0.R
##

library("vizgrimoire")

conf <- ConfFromOptParse()
SetDBChannel (database = conf$database, user = conf$dbuser, password = conf$dbpassword)

sql_res = 1 # 1 day resolution  SQL
period = conf$granularity
if (period == 'months'){
    sql_period = 'month'
}
if (period == 'weeks'){
    sql_period='week'
}
if (period == 'years'){
    sql_period='year'
}


identities_db = conf$identities_db

# dates
startdate <- conf$startdate
enddate <- conf$enddate

# Aggregated data
static_data <- mls_static_info(startdate, enddate)
latest_activity7 <- last_activity_mls(7)
latest_activity30 <- last_activity_mls(30)
latest_activity90 <- last_activity_mls(90)
latest_activity365 <- last_activity_mls(365)
static_data = merge(static_data, latest_activity7)
static_data = merge(static_data, latest_activity30)
static_data = merge(static_data, latest_activity90)
static_data = merge(static_data, latest_activity365)
createJSON (static_data, paste("data/json/mls-static.json",sep=''))

# Mailing lists
query <- new ("Query", sql = "select distinct(mailing_list) from messages")
mailing_lists <- run(query)

if (is.na(mailing_lists$mailing_list)) {
    print ("URL Mailing List")
    query <- new ("Query",
                  sql = "select distinct(mailing_list_url) from messages")
    mailing_lists <- run(query)
    mailing_lists_files <- run(query)
    mailing_lists_files$mailing_list = gsub("/","_",mailing_lists$mailing_list)
    # print (mailing_lists)
    createJSON (mailing_lists_files, "data/json/mls-lists.json")
    repos <- mailing_lists_files$mailing_list
    createJSON(repos, "data/json/mls-repos.json")	
} else {
    print (mailing_lists)
    createJSON (mailing_lists, "data/json/mls-lists.json")
	repos <- mailing_lists$mailing_list;
	createJSON(repos, "data/json/mls-repos.json")	
}

if (conf$reports == 'countries') {
    countries <- countries_names(identities_db, startdate, enddate) 
    createJSON (countries, paste("data/json/mls-countries.json",sep=''))
    
    for (country in countries) {
        if (is.na(country)) next
        print (country)
        data <- analyze.monthly.mls.countries.evol(identities_db, country, sql_res, startdate, enddate)
        # data <- completePeriod(data, period, conf)
        data <- completePeriodMulti(data, c('sent','senders'),period, 
                        conf$str_startdate, conf$str_enddate)
        
        createJSON (data, paste("data/json/",country,"-mls-evolutionary.json",sep=''))
        
        data <- analyze.monthly.mls.countries.static(identities_db, country, startdate, enddate)
        createJSON (data, paste("data/json/",country,"-mls-static.json",sep=''))
    }
}

for (mlist in mailing_lists$mailing_list) {
    analyze.monthly.list(mlist, sql_res, startdate, enddate, period)
}

data.monthly <- get.monthly(sql_res, startdate, enddate)
data.monthly <- completePeriodMulti(data.monthly, c('sent'),period, 
        conf$str_startdate, conf$str_enddate) 
createJSON (data.monthly, paste("data/json/mls-evolutionary.json"))

# Top senders
# top_senders_data <- top_senders_wo_affs(c("-Bot"), identities_db, startdate, enddate)
top_senders_data <- list()
top_senders_data[['senders.']]<-top_senders(0, conf$startdate, conf$enddate,identites_db)
top_senders_data[['senders.last year']]<-top_senders(365, conf$startdate, conf$enddate,identites_db)
top_senders_data[['senders.last month']]<-top_senders(31, conf$startdate, conf$enddate,identites_db)

createJSON (top_senders_data, "data/json/mls-top.json")

# People list
# query <- new ("Query", 
# 		sql = "select email_address as id, email_address, name, username from people")
# people <- run(query)
# createJSON (people, "data/json/mls-people.json")


# Companies information
if (conf$reports == 'companies'){
    
    company_names = companies_names(identities_db, startdate, enddate)
    # company_names = companies_names_wo_affs(c("-Bot", "-Individual", "-Unknown"), identities_db, startdate, enddate)

    createJSON(company_names$name, "data/json/mls-companies.json")
   
    for (company in company_names$name){       
        print (company)
        company_name = paste("'",company,"'",sep="")
        post_posters = company_posts_posters (company_name, identities_db, sql_res, startdate, enddate)
        post_posters <- completePeriodMulti(post_posters, c('sent','senders'),period, 
                conf$str_startdate, conf$str_enddate)        
        createJSON(post_posters, paste("data/json/",company,"-mls-evolutionary.json", sep=""))

        top_senders = company_top_senders (company_name, identities_db, period, startdate, enddate)
        createJSON(top_senders, paste("data/json/",company,"-mls-top-senders.json", sep=""))

        static_info = company_static_info(company_name, identities_db, startdate, enddate)
        createJSON(static_info, paste("data/json/",company,"-mls-static.json", sep=""))
    }
}

# Demographics

demos <- new ("Demographics","mls")
demos$age <- as.Date(conf$str_enddate) - as.Date(demos$firstdate)
demos$age[demos$age < 0 ] <- 0
aux <- data.frame(demos["id"], demos["age"])
new <- list()
new[['date']] <- conf$str_enddate
new[['persons']] <- aux
createJSON (new, "data/json/mls-demos-pyramid.json")