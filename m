From: Nix <nix@esperi.org.uk>
Subject: Re: A random initramfs script
Date: Fri, 17 Mar 2006 14:58:14 +0000
Message-ID: <87fylhp189.fsf@hades.wkstn.nix>
References: <87u0a0so6w.fsf@hades.wkstn.nix>
	<20060315002527.GO27173@skl-net.de> <87lkvcrtzu.fsf@hades.wkstn.nix>
	<20060315185750.GP27173@skl-net.de> <87hd5zs9zm.fsf@hades.wkstn.nix>
	<20060316002330.GT27173@skl-net.de> <87zmjqq14r.fsf@hades.wkstn.nix>
	<20060316234613.GX27173@skl-net.de> <87r751q4wi.fsf@hades.wkstn.nix>
	<20060317033540.GE14051@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060317033540.GE14051@skl-net.de> (Andre Noll's message of
 "Fri, 17 Mar 2006 04:35:40 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Mar 2006, Andre Noll murmured woefully:
> On 00:41, Nix wrote:
> 
>> > So I downloaded iproute2-2.4.7-now-ss020116-try.tar.gz, but there
>> > seems to be a problem with errno.h:
>> 
>> Holy meatballs that's ancient.
> 
> It is the most recent version on the ftp server mentioned in the HOWTO.

OK, so I guess the howto is a bit out of date :/

>> [uClibc]
>> 
>> Alternatively, just suck down GCC from, say, svn://gcc.gnu.org/svn/gcc/tags/gcc_3_4_5_release,
>> or ftp.gnu.org, or somewhere, and point buildroot at that.
> 
> Yep, there's a 'dl' directory which contains all downloads. One can
> download the tarballs from anywhere else to that directory. Seems to
> work now.

Ah, I just work from svn checkouts :) but they *are* twice the size of
a normal tarball, so I guess I understand using the tarballs instead :)

-- 
`Come now, you should know that whenever you plan the duration of your
 unplanned downtime, you should add in padding for random management
 freakouts.'
