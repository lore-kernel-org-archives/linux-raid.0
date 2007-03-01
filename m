From: rabbit@rabbit.us (Peter Rabbitson)
Subject: Re: RAID0 to RAID5 upgrade
Date: Thu, 1 Mar 2007 18:39:05 -0500
Message-ID: <20070301233905.GA13126@rabbit.us>
References: <45E75DE0.6060900@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45E75DE0.6060900@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 01, 2007 at 06:12:32PM -0500, Bill Davidsen wrote:
> I have three drives, with some various partitions, currently set up like 
> this.
> 
>  drive0    drive1    drive2
> 
>   hdb1      hdi1      hdk1
>   \_________RAID1________/
> 
>   hdb2      hdi2      hdk2
>  unused     \___RAID0____/
>   200GB       100GB x 2
> 
>             hdi3      hdk3
>             \___unused___/
>                100GB x 2
> 
> What I want to have is 3 x 200 = 400GB RAID5.
> 
> I would like to avoid copying 200GB of data to another machine and back 

Can't you do the following:

* copy the data from raid0 to hdb2 ( raid0 <= hdb2 you can even do a dd)
* degrade raid1 to only contain drive0
* since you have all your data on drive0, wipe drive1 and drive2 clean, 
create a degraded raid5
* copy stuff from drive0 to the new array (enw fs as well I presume)
* resync the raid5 with drive0


