From: Neil Brown <neilb@suse.de>
Subject: Re: Auto assembly errors with mdadm and 64K aligned partitions.
Date: Fri, 14 Dec 2007 10:58:46 +1100
Message-ID: <18273.50998.496550.840171@notabene.brown>
References: <200712131715.lBDHFitB005137@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from greg@enjellic.com on Thursday December 13
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 13, greg@enjellic.com wrote:
> Good morning to Neil and everyone on the list, hope your respective
> days are going well.
> 
> Quick overview.  We've isolated what appears to be a failure mode with
> mdadm assembling RAID1 (and presumably other level) volumes which
> kernel based RAID autostart is able to do correctly.
> 
> We picked up on the problem with OES based systems with SAN attached
> volumes.  I am able to reproduce the problem under 2.6.23.9 UML with
> version 2.6.4 of mdadm.
> 
> The problem occurs when partitions are aligned on a 64K boundary.  Any
> 64K boundary seems to work, ie 128, 256 and 512 sector offsets.
> 
> Block devices look like the following:
> 
> ---------------------------------------------------------------------------
> cat /proc/partions:
> 
> major minor  #blocks  name
> 
>   98     0     262144 ubda
>   98    16      10240 ubdb
>   98    17      10176 ubdb1
>   98    32      10240 ubdc
>   98    33      10176 ubdc1
> ---------------------------------------------------------------------------
> 
> 
> A RAID1 device was created and started consisting of the /dev/ubdb1
> and /dev/ubdc1 partitions.  An /etc/mdadm.conf file was generated
> which contains the following:
> 
> ---------------------------------------------------------------------------
> DEVICE partitions
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=e604c49e:d3a948fd:13d9bc11:dbc82862
> ---------------------------------------------------------------------------
> 
> 
> The RAID1 device was shutdown.  The following assembly command yielded:
> 
> ---------------------------------------------------------------------------
> mdadm -As
> 
> mdadm: WARNING /dev/ubdc1 and /dev/ubdc appear to have very similar superblocks.      If they are really different, please --zero the superblock on one
>       If they are the same or overlap, please remove one from the
>       DEVICE list in mdadm.conf.
> ---------------------------------------------------------------------------

Yes.  This is one of the problems with v0.90 metadata, and with
"DEVICE partitions".

As the partitions start on a 64K alignment, and the metadata is 64K
aligned, the metadata appears look  right for both the whole device
and for the last partition on the device, and mdadm cannot tell the
difference.

With v1.x metadata, we store the superblock offset which allows us to
tell if we have mis-identified a superblock that was meant to be part
of a partition or of the whole device.

If you make your "DEVICE" line a little more restrictive. e.g.

 DEVICE /dev/ubc?1

then it will also work.

Or just don't use partitions.  Make the arrat from /dev/ubdb and
/dev/ubdc.


NeilBrown
