From: Andrew Burgess <aab@cichlid.com>
Subject: Re: moving failing system disk to 2xnew RAID1
Date: Sat, 24 Dec 2005 11:24:12 -0800
Message-ID: <200512241924.jBOJOCTQ002276@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> What would the procedure be for moving the data off my (single) Maxtor onto a 
>> RAID1 of 2 WD800JBs?

>I wonder if I should just use the fedora installation disk to create a 
>RAID1 from the two WD disks and install it on there, then somehow copy 
>over the data from the Maxtor (perhaps while booted from a Live Linux CD)?

Create the raid1 and mkfs. Then 
  cp -aux / /raid
then boot single user and do it again to get the few files that have changed
(logs etc)

then adjust your boot program to boot from the raid

