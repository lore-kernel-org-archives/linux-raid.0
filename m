From: "David Lethe" <david@santools.com>
Subject: RE: sync_action repair not reading all sectors?
Date: Mon, 16 Mar 2009 10:04:57 -0500
Message-ID: <F2C688D6A021E34CB81C0E631EF4C093014C015D@34093-C4-EVS1.exchange.rackspace.com>
References: <49BE3786.50809@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <49BE3786.50809@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of David Greaves
> Sent: Monday, March 16, 2009 6:27 AM
> To: Neil Brown; linux-raid@vger.kernel.org
> Subject: sync_action repair not reading all sectors?
> 
> I have a drive that has bad sectors. Lots of them.
> 
> smartctl shows
> # 1  Short offline       Completed: read failure       20%       530
> 1953520877
> 
> A simple ddrescue to this part of the disk gets this:
> 
> Mar 16 10:41:28 elm kernel: [ 8643.123397] sd 3:0:0:0: [sdd]
1953525168
> 512-byte
> hardware sectors (1000205 MB)
> <snip<>51/40:00:f0:5c:70/00:00:74:00:00/e0 Emask 0x9 (media error)
> Mar 16 10:41:29 elm kernel: [ 8644.190060] ata4.00: status: { DRDY ERR
> }
> Mar 16 10:41:29 elm kernel: [ 8644.190099] ata4.00: error: { UNC }
> 
> and reports 30 or so errors.
> 
> 
> mdstat tells me:
> md0 : active raid5 sdd1[0] sdb1[2] sda1[1]
>       1953519872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> So sdd1 is in there.
> 
> /dev/sdd1 is the full disk
> 
> Now this is an enterprise class disk so I thought re-writing the
blocks
> would be
> worthwhile as a first step. (It is being RMAed but if it succeeds then
> I'll stop
> the array, mirror/replace the disk and start the array - less risky
> than a resync).
> 
> However (two runs of)
>   echo repair > /sys/block/md0/md/sync_action
> ran to completion without *any* errors being reported in syslog (or
> anywhere)
> 
> Is this expected? It suggests that it isn't reading the bad parts of
> sdd. It
> certainly hasn't repaired it and I'm none the wiser...
> 
> kernel is 2.6.26-1-xen-686
> mdadm v2.6.7.2
> 
> 
> PS
> This is an excellent place where I'd love to add in a new 'spare'
disk,
> mirror
> sdd to the new disk (apart from the bad sectors which should come from
> the
> array) and then swap new for old.
> Instead I'm going to have to go degraded and sync - risking a sector
> read
> failure on one of the other drives and a restore from backup :(
> 
> --
> "Don't worry, you'll be fine; I saw it work in a cartoon once..."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Personally, If I had a disk that just got this many bad sectors, then I
wouldn't mess
with it further.  Just RMA it and get it out of your computer. Every
block of data
you write to that disk is at risk, and since you are running RAID5, then
you have no room
for error if this disk, or one of the others should die on you and you
have a bad block
on one of the surviving disks.

David

