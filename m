From: "NeilBrown" <neilb@suse.de>
Subject: Re: 2.6.29 - raid10 issue - spares do not get synched automatically
Date: Sun, 29 Mar 2009 07:46:04 +1100 (EST)
Message-ID: <b5623e48a92119937c6527b7f9564ed4.squirrel@neil.brown.name>
References: <49CE19F0.5040809@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49CE19F0.5040809@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Ringl <patrick.ringl@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, March 28, 2009 11:37 pm, Patrick Ringl wrote:
> Hello,
>
> I am using 2.6.29 on a debian lenny. Anyway, I am having problems with a
> raid10 sandbox setup consisting of 4 loopback devices. To make a long
> story short:
>
> I created a raid10 array with all these 4 devices (loop0-loop3)
> then I set two devices faulty, removed them .. checked if I can still
> write to the array (which I could, so I/O errors, nothing in dmesg):
>
> BUT - here it comes: once I am trying to (re)add them (I zero'ed the
> superblock before) they're only getting added as spares and the array
> will not sync.
>
> Here's the logfile with mdadm -D /dev/md0 in between so one can see what
> is going on:
>
> http://pa#ste.debian.net/31758/
>

Linux RAID10 with

     Raid Level : raid10
   Raid Devices : 4
         Layout : near=2, far=1

Will layout data like this:

   disk0   disk1   disk2   disk3
     A       A       B       B
     C       C       D       D
     E       E       F       F

You have removed disk0 and disk1, so A,C,E don't exist
any more.  You should get IO errors when you try to access
that data.
There is nothing that can be recovered, so the drives remain
as spares.

NeilBrown


