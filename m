From: John Hendrikx <hjohn@xs4all.nl>
Subject: Reed Solomon coding based Raid?
Date: Sat, 28 Nov 2009 16:15:28 +0100
Message-ID: <4B113E90.50904@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was wondering if there is support for a raid level where one can 
choose the redundancy level.  Raid 5 allows for one redundant drive, 
Raid 6 for two, but there's no raid level that would support arbitrary 
redundancy (even to the point of allowing one to add extra redundancy 
later on, by simply putting spare drives to immediate use).

I'm just a casual Software Raid user, and have been using Raid 6 for a 
small 8 TB array for a few years now and I realize that there's quite 
some CPU overhead involved for such redundancy, but for my purposes 
speed is not a relevant concern (10 MB/sec is enough).

--John


