From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE - mdadm 0.8 - candidate for 1.0
Date: Wed, 10 Apr 2002 11:05:07 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15539.36803.487505.398985@notabene.cse.unsw.edu.au>
References: <15531.46606.314167.19186@notabene.cse.unsw.edu.au>
	<Pine.GSO.4.21.0204032025070.9004-100000@gecko.roadtoad.net>
	<15531.56527.518603.63636@notabene.cse.unsw.edu.au>
	<20020407125612.GC12349@colombina.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Sunday April 7
To: bluca@comedia.it
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 7, bluca@comedia.it wrote:
> On Thu, Apr 04, 2002 at 02:55:43PM +1000, Neil Brown wrote:
> > Yes... I sort of noticed that in passing...
> > 
> > I added:
> >    %_sbindir /sbin
> >    %_sysconfdir /etc
> > 
> > to my .rpcmacros and rebuild the rpms so they now put files in the
> > "right" places.
> > 
> > Any  RPM gurus want to suggest what I *should* do?
> i am no guru but an alterantive seems to be setting
> %define _exec_prefix %{nil}
> in the spec file

Thanks.  This looks like a reasonable suggestion.  And it seems to work.
> 
> > Is it wrong to use %_sbindir and $_sysconfdir ???
> i believe common practice is using /sbin literaly in the
> spec file, but i prefer the above thing
> 
> %_sysconfdir should be set to /etc in the per platform rpm macro file
> /usr/lib/rpm/%{_target_cpu}-%{_vendor}-%{_target_os}
> ie: /usr/lib/rpm/i386-redhat-linux

Hmmm. and debian's /usr/lib/rpm files set it to /usr/etc which doesn't
exist on debian :-(  I'll just assume that debian is broken and leave
_sysconfdir set to /etc in my .rpmmacros.

Thanks again,
NeilBrown
