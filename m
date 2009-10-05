From: adfas asd <chimera_god@yahoo.com>
Subject: RE: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 08:30:48 -0700 (PDT)
Message-ID: <556491.46402.qm@web38805.mail.mud.yahoo.com>
References: <20091005145711322.FNMG18886@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091005145711322.FNMG18886@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

WAT?!  How can I mount an unpartitioned/unformatted array?  This is more direct than using a filesystem, although there would be no journalling, right?  If I were to mount my small disk for / and the unpartitioned array as /home for example. 

Seems like journalling/crash recovery is pretty vital.  Could not partitioning be recommendable?


--- On Mon, 10/5/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> Partitions are not needed at all unless your underlying
> topology requires
> it:
> 
> `mdadm --create --raid-devices=2 --metadata=1.0 --chunk=128
> --level=1
> /dev/md0 /dev/sda /dev/sdb`
> 
>     Will work just fine.  You can also
> use LVM with raw disks.  Both
> systems simply stitch together storage units provided by
> the drive
> subsystem, so any block device found in /dev can be
> used.  Once the array is
> assembled, it is not necessary to partition it, either,
> again unless your
> overlaying topology requires it.  On my systems, the
> boot drives are
> partitioned to allow booting into Windows if necessary, and
> usually the swap
> is also in a partition on the boot drive, but my arrays are
> completely
> un-partitioned.
> 
> 


      
