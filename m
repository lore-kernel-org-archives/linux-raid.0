From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: moving failing system disk to 2xnew RAID1
Date: Sun, 25 Dec 2005 10:16:03 +0800
Message-ID: <dokvja$l78$1@sea.gmane.org>
References: <200512241924.jBOJOCTQ002276@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200512241924.jBOJOCTQ002276@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Burgess wrote:
>>> What would the procedure be for moving the data off my (single) Maxtor onto a 
>>> RAID1 of 2 WD800JBs?
> 
>> I wonder if I should just use the fedora installation disk to create a 
>> RAID1 from the two WD disks and install it on there, then somehow copy 
>> over the data from the Maxtor (perhaps while booted from a Live Linux CD)?
> 
> Create the raid1 and mkfs. Then 
>   cp -aux / /raid
> then boot single user and do it again to get the few files that have changed
> (logs etc)
> 
> then adjust your boot program to boot from the raid
> 

OK, sounds straight forward, but what about the /boot and swap partitions?

Max.

