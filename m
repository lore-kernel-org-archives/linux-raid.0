From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 18:10:49 +0100
Message-ID: <200501101810.49798.maarten@ultratux.net>
References: <crmt7e$8d6$1@sea.gmane.org> <200501101734.24851.maarten@ultratux.net> <Pine.LNX.4.56.0501101634250.17714@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501101634250.17714@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 10 January 2005 17:36, Gordon Henderson wrote:
> On Mon, 10 Jan 2005, maarten wrote:
> > P.S.:  I get this filling up my logs. Should I be worried about that ?
> > Jan 10 11:30:32 dozer kernel: raid5: switching cache buffer size, 512 -->
> > 4096 Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size,
> > 4096 --> 512 Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer
> > size, 512 --> 4096 Jan 10 11:30:36 dozer kernel: raid5: switching cache
> > buffer size, 4096 --> 512
>
> As I understand it, the "fix" is to comment it out in the kernel sources
> and compile & install a new kernel...

Ehm...?

> It seems to be an artifact of LVM - then only times I've seen lots of
> these are when I experimented with LVM... (incidentally I had some
> instability with the occasional panic with LVM, so dumped it for that
> particular application, and same hardware  & Kernel has been solid since)

I'm certain I saw it before, when I didn't use LVM at all.  Maybe the kernel 
scans for LVM at boot, but LVM was not in initrd for sure.

But is it dangerous or detrimental to performance (other than that it logs way 
too much) ?

Maarten

