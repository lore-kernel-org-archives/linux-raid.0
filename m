From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid5 on 2.4.21 and reconstruction problem
Date: Thu, 14 Aug 2003 11:44:39 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F3BAE67.EF1D509F@SteelEye.com>
References: <200308131236.44311.arekm@pld-linux.org> <16186.61292.498656.959026@gargle.gargle.HOWL> <200308141024.42208.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Arkadiusz Miskiewicz wrote:

> I'll check. Whole /dev/sdb device should be ok because I have part of

Not necessarily. You could be getting sector read/write errors on one
part of the disk while the rest of the disk is fine...

> /dev/md1 here, too (/dev/sdb3) and it's working fine.


> Why failed? - did it read that information from old superblock? 

Yes, if there was a superblock there, it would have read it.


> If yes then I
> have feature request: avility to mdadm to erease old superblocks from
> cmdline.

This feature already exists. Try mdadm --zero-superblock <dev>.

--
Paul
