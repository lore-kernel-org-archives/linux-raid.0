From: Ken <Ken@4dcsi.com>
Subject: hardware raid 5 and software raid 0 stripe broke.
Date: Thu, 11 May 2006 22:02:37 -0400
Message-ID: <4463ECBD.8040506@4dcsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We have a Linux box running redhat 7.2   We have two hardware 
controllers in it with about 500gig's each.   They're raid 5.   We were 
using a software raid to combine them all together.   1 hard drive went 
down so we replaced it and now the system won't boot.   We have used a 
Knoppix boot cd to get into a linux system.   We can see /dev/sda1 and 
/dev/sdb1.   However, /dev/md0 cannot be accessed.   Is there a safe way 
to create the software raid from the cd to see if maybe mdadm on the 
original system got corrupt?   any help would be greatly appreciated.

Sincerly,
Ken
