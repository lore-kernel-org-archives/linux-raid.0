From: Andre Noll <maan@systemlinux.org>
Subject: Re: A random initramfs script
Date: Fri, 17 Mar 2006 04:35:40 +0100
Message-ID: <20060317033540.GE14051@skl-net.de>
References: <87u0a0so6w.fsf@hades.wkstn.nix> <20060315002527.GO27173@skl-net.de> <87lkvcrtzu.fsf@hades.wkstn.nix> <20060315185750.GP27173@skl-net.de> <87hd5zs9zm.fsf@hades.wkstn.nix> <20060316002330.GT27173@skl-net.de> <87zmjqq14r.fsf@hades.wkstn.nix> <20060316234613.GX27173@skl-net.de> <87r751q4wi.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r751q4wi.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 00:41, Nix wrote:

> > So I downloaded iproute2-2.4.7-now-ss020116-try.tar.gz, but there
> > seems to be a problem with errno.h:
> 
> Holy meatballs that's ancient.

It is the most recent version on the ftp server mentioned in the HOWTO.

> Try <http://developer.osdl.org/dev/iproute2/download/iproute2-2.6.15-060110.tar.gz>
> for a rather newer and more capable copy. :)

Much better. Thanks. This version works fine for me, just like busybox
ip does.

> Yes, the initial population of /dev is done by firing messages at udevd
> *from a shell script*. It's gone all the way from devfs's kernel-space
> hardwiring to something sufficiently extensible that a shell script can
> do all the neessary stuff to populate /dev :)

Yeah, Linux rulez :)

> [uClibc]
> 
> Alternatively, just suck down GCC from, say, svn://gcc.gnu.org/svn/gcc/tags/gcc_3_4_5_release,
> or ftp.gnu.org, or somewhere, and point buildroot at that.

Yep, there's a 'dl' directory which contains all downloads. One can
download the tarballs from anywhere else to that directory. Seems to
work now.

Thanks
Andre
-- 
The only person who always got his work done by Friday was Robinson Crusoe
