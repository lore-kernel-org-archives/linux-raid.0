From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Mon, 15 Jun 2015 12:31:48 +0100
Message-ID: <BLU436-SMTP201B8FC9826A2A7B2F9199498B80@phx.gbl>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
	 <55767860.5000803@gmail.com> <55773493.3050605@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55773493.3050605@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Can Jeuleers <can.jeuleers@gmail.com>, Pierre Wieser <pwieser@trychlos.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2015-06-09 at 19:46 +0100, Wols Lists wrote:
> On 09/06/15 06:23, Can Jeuleers wrote:
> > On 08/06/15 21:28, Pierre Wieser wrote:
> >> Hi all,
> >>
> >> I currently have an almost full RAID 5 built with 4 x 2 TB disks.
> >> I wonder if it would be possible to migrate it to a bigger RAID 5
> >> with 3 x 6TB new disks.
> > 
> > I'd recommend against it:
> > 
> > https://en.wikipedia.org/wiki/RAID#Unrecoverable_read_errors_during_rebuild
> > 
> > Jan
> > 
> Please expand! Having read the article, it doesn't seem to say anything
> more than what is repeated time and time on this list - MAKE SURE YOUR
> DRIVES ARE DECENT RAID DRIVES.
> 
> If you have ERC, then the odd "soft" read error doesn't matter. If you
> don't have ERC, then your data is at risk when you replace a drive, and
> it doesn't matter how big your drives are, it's the array size that matters.

TLER doesn't actually affect the raid or its integrity compared to
non-tler drives (well strictly it _might_ as drives with tler might have
better lifespans, might have longer warranties (which suggests better
life), might have better URE rates, etc.) but the difference to how
mdadm handles things is actually down to the way the block device layer
handles things.

From what I can tell, with TLER the disk just gives up and reports an
error very quickly, this is then passed up the stack to the raid layer
which then tries to resolve the problem using various methods... a TLER
"error" does not mean the device is kicked, only if mdadm can't resolve
the problem does the device get booted. (I think it tries to recover the
data then tries to write recovered data back to the device, only if this
fails does the disk get booted)

Without TLER the disk tries to sort its own problems out instead of
reporting an error, this might take a long time, it might try to resolve
the problem forever in one long endless loop. The block layer (sdX)
knows it asked for something to happen, it gets bored and decides its
taken to long for the disk to return data so it decides that the disk no
longer exists, it (the device block layer as far as I can tell) kicks
the disk then passes on a message to mdadm that the disk is down for the
count and has been booted from the system.

I don't know who sets the block layer time out, or if it varies
depending on if the disk is a "file system" or is "a raid member" but
someone decided that after a few seconds the device should disappear/be
marked as bad within the system to prevent the raid from stalling, or as
a "normal" disk/file system various types of errors up to and including
a complete crash.

By setting the time out in the block layer /sys/block/sdX/device/timeout
to a high(ish) value the raid will stall (not a problem for most end
users, big no-no for a high end data server with 100's of users relying
on quick responses) or "hang" on a "normal" disk producing a frozen
screen or what not to the end user... while a pain, better than a disk
fail especially if eventually the disk internally manages to sort the
problem and give valid data back instead of the system crashing.

I set the block time out to 180 seconds on all disks (3 mins) for disks
with TLER enabled they will still give up and send an error message up
the stack in less than 7 seconds, for my other "green" drives with no
TLER they will try their best to recover and if not will eventually pass
the error up to the block layer or after 3 mins the block layer will
report they timed out to either mdadm or to the file system.

Unlike with mdadm and the block device which can be tuned, a hardware
raid will give up on the drive after 7 seconds and kick it (which is why
you should only use raid/TLER drives in a HW raid); at least with mdadm,
specifically the block device layer, depending on the type of drive and
how much internal (to the disk) error recovery is performed and how
important response times are you can use any old disk with mdadm raid
with no problems. 
It should also be noted that the same issue would happen without raid, a
pause/hang or a drive marked as failed and/or the system crashing if the
block layer gives up or an error message passed up to the file system if
the disk has TLER and is used in a non raid way... how the file system
handles it is up to the file system.

> 
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


