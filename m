From: Valentijn Sessink <v@lentijn.sess.ink>
Subject: Re: Corrupted Cisco NSS4000 raid
Date: Sat, 17 Jan 2015 18:27:22 +0100
Message-ID: <54BA9B7A.9070906@lentijn.sess.ink>
References: <54BA7E8F.1090601@excello.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54BA7E8F.1090601@excello.cz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Jan,

On 17-01-15 16:23, Jan Hejl wrote:
> right after finish rebuilding faulty, but still usable, RAID array on
> Cisco NSS4000 NAS box, array stopped working completly.

I'd go for
mdadm --assemble --force --run /dev/md666 $sdb $sdc $sdd
... because sdb, sdc and sdd seem to have the same number of "events" -
and sde has a lower number. However, sdc is a "spare" according to the
mdadm information, so that may not work, in which case you could try to
assemble sdb, sdd and sde and then later on try to recreate the array
with sdc in it.

sdb..d are variables in my "assemble" command, because I'd NEVER do this
on a live disk. Please see my posting about what I did to "clone" the
disks with dmsetup: http://valentijn.sessink.nl/?p=557 (I'm sure there
are other ways - having a disk image with "dd" would also help).

For dd to fill unreadable sectors of the source disks with zeroes,
you'll need a few options, otherwise dd will stop, or, even worse, just
"ignore" unreadable sectors like this: 01234xxx89  -> becomes 0123489 at
the target disk. What you want is 0123400089 (unreadable, but not
truncated). "conv=sync,noerror" is, IIRC, the right option but please
check this (I didn't)

Using 3 out of 4 disks will not help you work around read errors on the
disks themselves, so you may want to use smartctl first to see what the
disk statuses are. Using /dev/sde in the array could work, but as it has
a lower "events" count, you can expect to lose some data.

I woudn't go for 4 out of 4 disks, because that will start rebuilding
the array as soon as you have it read/write and you don't want to change
data on any one of the disks.

If "assemble" doesn't work, you could use "create". Please note that
different versions of mdadm have different ideas about "Data Offset",
and only the newest mdadm can handle a user defined data offset, with
the "--data-offset" option. So your best bet for now is using
assemble+force, although I have seen situations where mdadm will just
not assemble the array due to one or more disks having different
information than mdadm expects.

I hope this helps. Good luck.

Best regards,

Valentijn
