From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Adding Raid 1 to Raid 0 on Linux
Date: Thu, 29 Nov 2012 18:12:11 -0700
Message-ID: <9AB1F362-3E78-43A7-94FA-53D6E1C12E2B@colorremedies.com>
References: <CAAo+KFmrVi4jd=F=Umjjf4VqdV8GW4oh24S+pO2yzteMVJf1Pg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAo+KFmrVi4jd=F=Umjjf4VqdV8GW4oh24S+pO2yzteMVJf1Pg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Nov 29, 2012, at 5:44 PM, Oguz Yilmaz <oguzyilmazlist@gmail.com> wrote:

> Hello,
> 
> I have a system already configured with raid 1 with 2 disks:
> 
> /dev/md1             918347072 249416692 621528596  29% /var
> /dev/md0               9920532    160640   9247828   2% /tmp
> 
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sdc5[0] sdb5[1]
>      948035712 blocks [2/2] [UU]
> 
> md0 : active raid1 sdc2[0] sdb2[1]
>      10241344 blocks [2/2] [UU]
> 
> I have asked for changing this into Raid 0+1 (striped raid is
> mirrored, http://en.wikipedia.org/wiki/Nested_RAID_levels#RAID_0.2B1 )
> 
> How can I change this partition into Raid 01 after adding 2 more disks
> without formatting?

I think you have to start from scratch. You can however stripe the mirrors and make it a RAID 10 which is more reliable anyway. I'm not sure what the difference is between separate steps for creating RAID 1, then RAID 0'ing those mirors, versus setting up RAID 10 from the outset as one step.


Chris Murphy