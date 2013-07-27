From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovery help? 4-disk RAID5 double-failure, but good disks have
 event count mismatch.
Date: Sat, 27 Jul 2013 16:43:55 -0400
Message-ID: <51F4310B.3050709@turmel.org>
References: <CABR0jES0HHeyM6_7-whqLQgF6a+u4PCDAdyWPJ5Bp8g1umi2jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABR0jES0HHeyM6_7-whqLQgF6a+u4PCDAdyWPJ5Bp8g1umi2jA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael@edgeofthenet.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Richard,

On 07/27/2013 12:46 PM, Richard Michael wrote:
> Hello everyone,
> 
> I have inherited a failed RAID5 and am attempting to recover as much
> data as possible.   Full mdadm -E output at the bottom.

Please also supply "smartctl -x /dev/sdX" for each of your drives.

> The RAID is 4 SATA disks, /dev/sd[abcd]3 and EXT4.
> 
> One disk is unable to talk to the controller, another is out-of-date,
> the remaining two are current and match each other.
> 
> sdb spins up but fails to talk, the kernel hard resets the link
> several times, then slows the link to 1.5Gb/s and retries, then
> eventually gives up entirely (fail; then "EH complete").  I have no
> /dev node, etc..

Is this still true if you plug it into a different computer?

> Bad sectors were found while ddrescue-coping sdc.  It was actually
> kicked from the array back on 14-July-2013 02:26:00, and thus has a
> lower event count than the remaining two good disks.
> 
> /dev/sdc3:
>   Update Time : Sun Jul 14 02:26:00 2013
>   Checksum : 5a16857a - correct
>   Events : 308375
> 
> 
> The remaining, functioning, disks sd[ad]3 are in "sync" with each
> other, but 10 days (~70,000 events) ahead of sdc3:
> 
> /dev/sd[ad]3:
>   Update Time : Wed Jul 24 14:01:52 2013
>   Checksum : d7cff537 - correct
>   Events : 378389

Ok.  This all makes sense.


> Questions:
> 
> 0/ Any thoughts on the best method to proceed with recovery?

First, determine if the problem with /dev/sdb is a failed drive, failed
cabling, or failed controller.  If either of the latter, attempt to
force assembly with /dev/sd[abd] in a working controller/cabling
environment.

> 1/ What will happen if I --assemble --force?  I think the low event
> count on sdc3 will be forced up to 378389 and the array will start
> degraded.  The filesystem will be corrupted (missing "real/updated"
> data on sdc3), but I can fsck and check lost+found to find damaged
> file names.  I'll md5sum all against the latest (but old) "backup" to
> find silent corruption.

You are correct.  If /dev/sdb is truly dead, this is the best you can do.

> 2/ Could the write intent bitmap on sd[ad]3 go far enough back to
> replay the last ~70K events to sdc3?  Generally, what are the
> limitations of the bitmap -- how many events can be replayed?  I'm not
> sure I have a clear understanding of the WIBM.

Write-intent bitmaps do not contain events.  Just markers for blocks of
sectors that have been written to while an array is degraded.  The
bitmap is an optimization useful when re-adding a failed drive to an
otherwise working array.

> 3/ Should the sdc superblock indicate information about it being
> kicked?  It's listed as "clean" and sees all the drives active
> ('AAAA').

Drives are generally kicked out of an array when MD fails to write to
them.  If MD cannot write to a drive, how do you expect it to update
that drive's superblock?  Detecting this phenomenon (re-appearance of a
failed drive) is precisely why each drive maintains an event count and a
list of the other drives status.

> 4/ Perhaps beyond the scope of linux-raid, I'm not sure what to do
> about sdb.  I've tried different positions on the controller, and
> re-orienting the drive (vertical, sideways, etc.).  I could send it
> alone for recovery, perhaps.  I don't know how to get lower-level than
> the kernel failing to talk to the device.  Perhaps a vendor diagnostic
> tool?

Try different controllers, different cables (power and data), and if all
else fails, different computer.  If you do get it talking, include its
"smartctl -x" report too.

> Thank you very much in advance for your time and comments.  I hope
> you're all having a better weekend than I am. :-)

Hope this helps,

Phil
