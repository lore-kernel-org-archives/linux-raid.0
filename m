From: Derek Vadala <derek@cynicism.com>
Subject: Re: Creating Raid10 with mdadm
Date: Thu, 10 Oct 2002 15:00:54 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021010190054.A89173B808@jaded.cynicism.com>
References: <1034268658.22354.84.camel@ralph.plexio.private>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1034268658.22354.84.camel@ralph.plexio.private>
To: Stephen Lee <splee@plexio.com>
Cc: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10 Oct 2002, Stephen Lee wrote:

> Can anyone point me to an example of how to create a raid10 with 4 scsi
> drives using mdadm? I have created raid1 and raid5 using mdadm so it's a
> matter of getting the md device naming and grouping correct. This is for
> a Redhat7.3 box.

First create each of the mirrors:
(dont forget to susbstitute the proper SCSI devices for your system)

mdadm -Cv /dev/md0 -l1 -n2 /dev/sda1 /dev/sdb1
mdadm -Cv /dev/md1 -l1 -n2 /dev/sdc1 /dev/sdd1

Now create a RAID-0 that uses /dev/md0 and /dev/md1 as its component
disks:

mdadm -Cv /dev/md2 -l0 -n2 /dev/md0 /dev/md1

So your RAID-10 is at /dev/md2 and it contains the mirror member arrays
/dev/md0 and /dev/md1.

Don't forget that you need to start /dev/md0 and /dev/md1 before you can
start /dev/md2.

---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

