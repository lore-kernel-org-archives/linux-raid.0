From: danci@agenda.si
Subject: Re: badblocking an md device?
Date: Sun, 20 Oct 2002 08:22:47 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210200807420.20909-100000@duplo.agenda.si>
References: <02101915322700.23139@diva.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02101915322700.23139@diva.localdomain>
To: John Sutton <john@scl.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Oct 2002, John Sutton wrote:

> e2fsck -f -n -l bblist /dev/md0
>
> Finally, add the disk back into the array:
>
> raidhotadd /dev/md0 /dev/sda5
>
> I can't see why that shouldn't work (but OTOH I'm a newbie with raid ;-)
> and the filesystem has not even been unmounted.  Of course, if a badblock
> has been detected which lies beyond the filesystem i.e. in the raid
> superblock, then you've had it.  (This will be obvious because the block
> will be rejected by the e2fsck as being out of range.)

This should work with RAID-1.

> BTW, I've seen mention on this list of a low level scsi formatting utility
> (scsiformat) for remapping bad blocks but I don't seem to have it on my
> RH7.1 system.  Can anyone tell me where I can find it (preferably the
> source)?

ftp://ftp.fokus.gmd.de/pub/unix/sformat/



   D.


