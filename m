From: Gabor Gombas <gombasg@digikabel.hu>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 22:28:11 +0100
Message-ID: <20100214212811.GB15313@twister.home>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <20100214193406.GA15722@khazad-dum.debian.net>
 <4B786154.8090103@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B786154.8090103@shiftmail.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Michael Evans <mjevans1983@gmail.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 14, 2010 at 09:47:16PM +0100, Asdo wrote:

> 1.x autodetection worked great for me in initramfs. Basically you
> only need /etc/mdadm/mdadm.conf copied to initramfs (via
> update-initramfs),

There is no autodetection with 1.1. Once you have mdadm.conf you have
pretty hard rules about what to look for and how to assemble it - ie.
there is not much left to "auto" detect. Real autodetection would mean
there is _no_ such information available, and you figure out everything
by just looking at the devices you find.

> initramfs procedure.
> Also consider 1.x allows to choose which arrays are autoassembled
> (hostname written in the array name equal to hostname in the machine
> or specified in mdadm.conf): this is more precise than 0.9 which
> autoassembles all, I think.

And also causes much more pain when you install machines on an internal
network where it gets a random name (in fact all new machines get the
same temporary name), then it is moved to its real location and
reconfigured with its real name. And you wonder why your arrays aren't
assembled any more...

Gabor
