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
## This file is a part of the vizGrimoire R package
##  (an R library for the MetricsGrimoire and vizGrimoire systems)
##
## mailinglists.R
##
##
## Authors:
##   Daniel Izquierdo <dizquierdo@bitergia.com>




#Evolutionary functions
test.EvolEmailsSent.Week <- function()
{
    expect_that(50, equals(nrow(EvolEmailsSent('week', "'2012-01-01'", "'2013-01-01'", NA, list(NA, NA)))))
}

test.EvolEmailsSent.Month <- function()
{
    expect_that(12, equals(nrow(EvolEmailsSent('month', "'2012-01-01'", "'2013-01-01'", NA, list(NA, NA)))))
}

test.EvolEmailsSent.Company <- function()
{
    expect_that(12, equals(nrow(EvolEmailsSent('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('company', "'Red Hat'")))))
}


test.EvolMLSSenders.Week <- function()
{
    expect_that(50, equals(nrow(EvolMLSSenders('week', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list(NA, NA)))))
}

test.EvolMLSSenders.Month <- function()
{
    expect_that(12, equals(nrow(EvolMLSSenders('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list(NA, NA)))))
}

test.EvolMLSSenders.Company <- function()
{
    expect_that(11, equals(nrow(EvolMLSSenders('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('company', "'Rackspace'")))))
}


test.EvolMLSSendersResponse.Week <- function()
{
    expect_that(50, equals(nrow(EvolMLSSendersResponse('week', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list(NA, NA)))))
}

test.EvolMLSSendersResponse.Month <- function()
{
    expect_that(12, equals(nrow(EvolMLSSendersResponse('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list(NA, NA)))))
}

test.EvolMLSSendersResponse.Company <- function()
{
    expect_that(11, equals(nrow(EvolMLSSendersResponse('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('company', "'Rackspace'")))))
}


test.EvolMLSSendersInit.Week <- function()
{
    expect_that(50, equals(nrow(EvolMLSSendersInit('week', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list(NA, NA)))))
}

test.EvolMLSSendersInit.Month <- function()
{
    expect_that(12, equals(nrow(EvolMLSSendersInit('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list(NA, NA)))))
}

test.EvolMLSSendersInit.Company <- function()
{
    expect_that(7, equals(nrow(EvolMLSSendersInit('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('company', "'Rackspace'")))))
}


test.EvolThreads.Week <- function()
{
    expect_that(50, equals(nrow(EvolThreads('week', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list(NA, NA)))))
}

test.EvolThreads.Month <- function()
{
    expect_that(12, equals(nrow(EvolThreads('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list(NA, NA)))))
}

test.EvolThreads.Company <- function()
{
    expect_that(11, equals(nrow(EvolThreads('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('company', "'Rackspace'")))))
}

#Uncomment tests when dataset is available in MySQL
#test.EvolMLSDomains.Week <- function(){
#    print(EvolMLSDomains('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('domain', "'Rackspace'")))
#}

#test.EvolMLSCountries.Week <- function(){
#    print(EvolMLSCountries('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('country', "'Rackspace'")))
#}

test.EvolMLSCompanies.Month <- function(){
    expect_that(12, equals(nrow(EvolMLSCompanies('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db))))
}

#Uncomment tests when dataset is available in MySQL
#test.AggMLSDomains.Week <- function(){
#    print(AggMLSDomains('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('domain', "'Rackspace'")))
#}

#test.AggMLSCountries.Week <- function(){
#    print(AggMLSCountries('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db, list('country', "'Rackspace'")))
#}

test.AggMLSCompanies.Month <- function(){
     expect_that(24, equals(as.numeric(AggMLSCompanies('month', "'2012-01-01'", "'2013-01-01'", conf$identities_db))))
}

