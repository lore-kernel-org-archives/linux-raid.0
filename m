From: Luca Berra <bluca@comedia.it>
Subject: Re: ANNOUNCE - mdadm 0.8 - candidate for 1.0
Date: Sun, 7 Apr 2002 14:56:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020407125612.GC12349@colombina.comedia.it>
References: <15531.46606.314167.19186@notabene.cse.unsw.edu.au> <Pine.GSO.4.21.0204032025070.9004-100000@gecko.roadtoad.net> <15531.56527.518603.63636@notabene.cse.unsw.edu.au>
Reply-To: bluca@comedia.it
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15531.56527.518603.63636@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 04, 2002 at 02:55:43PM +1000, Neil Brown wrote:
> Yes... I sort of noticed that in passing...
> 
> I added:
>    %_sbindir /sbin
>    %_sysconfdir /etc
> 
> to my .rpcmacros and rebuild the rpms so they now put files in the
> "right" places.
> 
> Any  RPM gurus want to suggest what I *should* do?
i am no guru but an alterantive seems to be setting
%define _exec_prefix %{nil}
in the spec file

> Is it wrong to use %_sbindir and $_sysconfdir ???
i believe common practice is using /sbin literaly in the
spec file, but i prefer the above thing

%_sysconfdir should be set to /etc in the per platform rpm macro file
/usr/lib/rpm/%{_target_cpu}-%{_vendor}-%{_target_os}
ie: /usr/lib/rpm/i386-redhat-linux

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
