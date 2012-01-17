From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID6, failed device, unresponsive system?
Date: Tue, 17 Jan 2012 12:02:12 +0000
Message-ID: <20245.25412.868844.285385@tree.ty.sabi.co.UK>
References: <CADNH=7FyxQ=C=gdirjpTsc5q0tJ2=SSXtryRM36icTH=ncC_0A@mail.gmail.com>
	<CADNH=7GrCN5ec5YahZvAGiHTW65eiptE74KN=F1oe_gGQpHTow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GrCN5ec5YahZvAGiHTW65eiptE74KN=F1oe_gGQpHTow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> Why is the system unresponsive, shouldn't it still be OK
>> after a drive failure?

There is a bit of a difference between a "drive failure" and
some/several bad sectors on a drive.

It is also to wonder whether the partially defective drive has
been "failed" and "removed" from the MD set and perhaps
"deleted" using '/sys/block/sdb/device/delete'.

> Hm, I'm seeing this in dmesg, could it be related? (ioctl lock)

> [425480.928740] md/raid:md0: read error corrected (8 sectors at
> 223617240 on sdb1)

Note the "read error corrected" (*corrected*) and that is is "8
sectors" may indicate it is one of the drives with 4096B sectors
that is configured as if it has 512B ones.

[ ... ]

Overall it is likely that you have just implicitly discovered
how important short settings for Error Recovery Control are, and
to choose drives that allow you to set them:

  http://www.sabi.co.uk/blog/1103Mar.html#110331
