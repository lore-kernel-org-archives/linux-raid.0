From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Doesn't "writes" do what resync does ?
Date: Mon, 30 Dec 2013 01:25:19 -0600
Message-ID: <52C11FDF.1040307@hardwarefreak.com>
References: <52C0AD5A.1040802@insync.za.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C0AD5A.1040802@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/29/2013 5:16 PM, Pieter De Wit wrote:
> Hi List,
> 
> As per my previous email, I am busy shifting a bunch of data around. I
> have just created a new RAID1 set, following which MD started resyncing it.
> 
> Before that completed, I started shifting data onto it. I always thought
> that writing data to a new array, does "exactly" what resyncing does (it
> has to do all the same calcs etc)
> 
> This doesn't seem to be the case:
> 
> md2 : active raid1 sdd2[1] sda2[0]
>       243567616 blocks super 1.2 [2/2] [UU]
>       [===>.................]  resync = 17.2% (41949184/243567616)
> finish=122.3min speed=27454K/sec
> 
> yet:
> 
>   --- Physical volume ---
>   PV Name               /dev/md2
>   VG Name               RAID
>   PV Size               232.28 GiB / not usable 35.00 MiB
>   Allocatable           yes
>   PE Size               4.00 MiB
>   Total PE              59456
>   Free PE               811
>   Allocated PE          58645
>   PV UUID               my6BsX-cSPD-MTKK-8U0t-ULVl-MKcA-LcAW2D
> 
> All the data on here was moved from another RAID device and currently
> contains about 200gig of data.
> 
> Should that resync not have had more completed ?

Your question is invalid.  What you meant to ask is

"Why are pvdisplay and mdstat reporting what seems to be conflicting
state data?"

Did you also ask on the lvm list why pvdisplay says most PEs are
consumed, yet mdstat says resync is only 17% complete?

-- 
Stan

