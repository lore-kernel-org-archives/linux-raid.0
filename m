From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 16:36:34 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501101634250.17714@lion.drogon.net>
References: <crmt7e$8d6$1@sea.gmane.org> <200501081749.32816.maarten@ultratux.net>
 <200501082001.09317.maarten@ultratux.net> <200501101734.24851.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101734.24851.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 Jan 2005, maarten wrote:

> P.S.:  I get this filling up my logs. Should I be worried about that ?
> Jan 10 11:30:32 dozer kernel: raid5: switching cache buffer size, 512 --> 4096
> Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size, 4096 --> 512
> Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size, 512 --> 4096
> Jan 10 11:30:36 dozer kernel: raid5: switching cache buffer size, 4096 --> 512

As I understand it, the "fix" is to comment it out in the kernel sources
and compile & install a new kernel...

It seems to be an artifact of LVM - then only times I've seen lots of
these are when I experimented with LVM... (incidentally I had some
instability with the occasional panic with LVM, so dumped it for that
particular application, and same hardware  & Kernel has been solid since)

Gordon
