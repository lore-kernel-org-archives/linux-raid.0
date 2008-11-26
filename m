From: "michael" <michael@estone.ca>
Subject: Re: Updated MDADM, array dies.
Date: Wed, 26 Nov 2008 13:16:09 -0800
Message-ID: <20081126211439.M92990@estone.ca>
References: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 26 Nov 2008 11:40:52 -0500, Greg Cormier wrote
> I have a RAID5 array of 4 disks. Was working well. I did a "yum
> update" and noticed it updated mdadm to mdadm 2.6.7.1, amongst other
> things (new kernel 2.2.27 instead of .26) , and now my array won't
> mount.
> 
> mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> mdadm: cannot open device /dev/sdb1: Device or resource busy
> mdadm: /dev/sdb1 has no superblock - assembly aborted
> 
> [root@zeus ~]# cat /proc/mdstat
> Personalities :
> md_d0 : inactive sdb1[0](S) sdd1[2](S)
>       976766976 blocks
> 
> unused devices: <none>
> 

Did your md devices get renamed?
You are trying to assemble md0 but yet proc/mdstat shows md_d0
as the device name.


