From: "Sandra Escandor" <sescandor@evertz.com>
Subject: RE: Resolving mdadm built RAID issue
Date: Mon, 11 Jul 2011 11:04:21 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD8CC6C@otis.burlington.evertz.tv>
References: <C70A636B101FD44999B82525C3E92AFAD8CB1E@otis.burlington.evertz.tv> <1310152936.3079.5.camel@baal>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1310152936.3079.5.camel@baal>
Sender: linux-raid-owner@vger.kernel.org
To: "Tyler J. Wagner" <tyler@tolaris.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been looking into this issue, and from what I've read on other
message boards with similar ata error warnings (their failed command is
READ FPDMA QUEUED and mine is WRITE), it could be a RAID member disk
failure - but, wouldn't /proc/mdstat output show that a RAID member disk
can no longer be used if it has write errors? Please correct me if I'm
wrong.

Here is more system info and the output of cat /proc/mdstat:

[91269.681462]   res 41/10:00:1f:9d:17/00:00:0b:00:00/40 Emask 0x481
(invalid argument) <F>

[91269.681539]   ata6.00: status { DRDY ERR )

[91269.681561]   ata6.00: error: { IDMF }

[91303.180111]   ata6.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action
0x0

[91393.180139]   ata6.00: irq_stat 0x40000008

[91303.180161]   ata6.00: failed command: WRITE FPDMA QUEUED

[91303.180186]   ata6.00: cmd 61/08:88:4f:4e:02/00:00:00:00/40 tag 1 ncq
4096  out

 

-          "$ sudo cat /proc/mdstat" returns:

 

Personalities : [raid10]

md126 : active raid10 sdb[3] sdc[2] sdd[1] sde[0]

      1465144320 blocks super external:/md127/0 64K chunks 2 near-copies
[4/4] [UUUU]

 

md127 : inactive sdb[3](S) sdc[2](S) sdd[1](S) sde[0](S)

      9028 blocks super external:imsm

 

unused devices: <none>


-----Original Message-----
From: Tyler J. Wagner [mailto:tyler@tolaris.com] 
Sent: Friday, July 08, 2011 3:22 PM
To: Sandra Escandor
Cc: linux-raid@vger.kernel.org
Subject: Re: Resolving mdadm built RAID issue

On Fri, 2011-07-08 at 14:07 -0400, Sandra Escandor wrote:
> I am trying to help someone out in the field with some RAID issues,
and
> I'm a bit stuck. The situation is that our server has an ftp server
> storing data onto a RAID10. There was an Ethernet connection loss
(looks
> like it was during an ftp transfer) and then the RAID experienced a
> failure. From the looks of the dmesg output below, I suspect that it
> could be a member disk failure (perhaps they need to get a new member
> disk?). But, even still, this shouldn't cause the RAID to become
> completely unusable, since RAID10 should provide redundancy - a resync
> would start automatically once a new disk is inserted, correct? 

It does appear that you've had a disk failure on /dev/sde. However, I
can't tell from the dmesg output alone what is the current state of
array. Please give us the output of:

cat /proc/mdstat
mdadm --detail /dev/md126

Simply inserting a new disk will not resync the array. You must add the
remove the old disk from the array, and add the new one using:

mdadm --fail /dev/sde --remove /dev/sde
(insert new disk
mdadm --add /dev/sde

However, I'm guessing as to your layout. /dev/sde may not be correct if
you've partitioned the drives. Then it would may be /dev/sde1, or sde2,
etc.

Regards,
Tyler

-- 
"It is an interesting and demonstrable fact, that all children are
atheists
and were religion not inculcated into their minds, they would remain
so."
   -- Ernestine Rose

