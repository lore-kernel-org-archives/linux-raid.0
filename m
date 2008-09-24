From: "michael@kmaclub.com" <michael@kmaclub.com>
Subject: Re: problem adding disk
Date: Wed, 24 Sep 2008 07:22:27 -0700
Message-ID: <48DA4D23.5030704@kmaclub.com>
References: <18649.35056.921038.589168@notabene.brown> <48D9B779.1060309@principia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48D9B779.1060309@principia.edu>
Sender: linux-raid-owner@vger.kernel.org
To: chrise@principia.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Eddington wrote:
> Hi,
> 
> I had a disk failure and replaced it with an equivalent disk, partition, 
> etc.
> It seems to add correctly to the existing array when using mdadm 
> /dev/md0 --add /dev/sdd1 after re-syncing, but when I restart the array 
> (or reboot) it never accepts it, reporting the message below.  It thinks 
> the 4th partition is <sdd> instead of sdd1.
> Turns out that /dev/sdd1 does not exist, but fdisk -l reports that it is 
> there (also below).
> Try to start the array with just sdd does not work either:
> altair:~$ sudo mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 
> /dev/sdd
> mdadm: /dev/md0 has been started with 3 drives (out of 4).
> altair:~$ sudo mdadm --stop /dev/md0

Looks similar to an issue I had a month ago:

http://marc.info/?l=linux-raid&m=121882238819928&w=2

Does this sound like the same problem to you?

With Neil's solution:

mdadm --zero-superblock /dev/sdg

You would need to adjust it to /dev/sdd.

Michael
