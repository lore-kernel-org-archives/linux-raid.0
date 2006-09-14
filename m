From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: access array from knoppix
Date: Thu, 14 Sep 2006 12:16:38 -0400
Message-ID: <45098066.6020303@maine.edu>
References: <200609121352.08834.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609121352.08834.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Dexter Filmore wrote:

> When running Knoppix on my file server, I can't mount /dev/md0 simply because 
> it isn't there. 
> Am I guessing right that I need to recreate the array?
> How do I gather the necessary parameters?

 From the man page:

	mdadm -Ac partitions -m 0 /dev/md0

This will "assemble" the array, as opposed to "create".  It says to look 
in /proc/partitions for viable partitions and then assemble the array 
with devices that have a superblock minor number of 0.  Once done, 
/dev/md0 will exist.  Tuomas was not being a "wisecracker".  His advice 
was valid.

Steve



