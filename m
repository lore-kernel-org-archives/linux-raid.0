From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Terrible slow write speed to MegaRAID SCSI array
Date: Sat, 18 Mar 2006 13:55:21 +0300
Message-ID: <441BE719.1010308@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

We've installed an LSI Logic MegaRaid SCSI 320-1 card
on our server (used only temporarily to move data to
larger disks, but that's not the point), and measured
linear write performance, just to know how much time
it will took to copy our (somewhat large) data to the
new array.  And to my surprize, this card, with current
firmware, current (2.6.15) kernel and modern disks is
terrible slow on writing - writing speed varies between
1.5 megabutes/sec to 10 megabytes/sec, depending on the
logical drive settings in the megaraid adapter.

I tried different raid configurations (raid10 - 3 spans
of two-disk raid1s; raid1 out of 2 drives; raid 0 on one
drive) - makes no difference whatsoever (but on raid1,
I only can get 8 megabytes/sec write speed - 10 mb/sec
is on raid10).

The disks are 140Gb FUJITSU MAT3147NC ones, pretty modern.
One disk, when plugged into non-megaraid card and accessed
as single disk, delivers about 60 megabytes/sec write speed,
and about 80 mb/sec read (reading speed on megaraid array
is quite good - about 240 mb/sec for 6-disk raid10).

I've upgraded firmware on the megaraid card to the latest one
available on lsi logic website - nothing changed wrt write
speed (but read speed decreased from 240 to about 190 mb/sec -
still acceptable for me).

I'm using megaraid_mbox driver.

The only "improvement" I was able to get is when I enable
write caching on the card, -- in this case, writing speed
is very good up to first 64Mb (amount of memory on the
card), and decreases again back to 1.5..10 mb/sec after
64Mb.

The question is: where's the problem? linux? driver? hardware?
Anyone else expirienced this problem?

Thanks.

/mjt
