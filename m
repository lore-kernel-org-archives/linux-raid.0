From: Nix <nix@esperi.org.uk>
Subject: Re: mdadm 2.5.2 - Static built , Interesting warnings when
Date: Tue, 27 Jun 2006 22:53:50 +0100
Message-ID: <87fyhqfeoh.fsf@hades.wkstn.nix>
References: <17569.6292.142280.859690@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606271147410.12026@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0606271147410.12026@filesrv1.baby-dragons.com> (James W. Laferriere's message of "27 Jun 2006 19:52:26 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27 Jun 2006, James W. Laferriere uttered the following:
> 	Hello All ,  What change in Glibc mekes this necessary ?  Is there a

glibc 2.x has always had the requirement that lookups that use the NSS
mechanism require the use of dynamically linked libraries. This is not
new.

Solaris (from which the idea of NSS is taken) has the same constraint,
but more strictly enforced: they don't have glibc's hacks to allow
dlopen() to work from statically linked apps, so they simply *don't
provide* getpwnam() et al in their static libc. (As of Solaris 10 they
don't provide a static libc at all.)

> 	method available to include the getpwnam & getgrnam structures so that
> 	full static build will work .  Tia ,  JimL

The full static build *does* work. But, as the warning says,

> config.o(.text+0x8c4): In function `createline': /home/archive/mdadm-2.5.2/config.c:341: warning: Using 'getgrnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> config.o(.text+0x80b):/home/archive/mdadm-2.5.2/config.c:326: warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking

... you can't expect to run this mdadm on a system that does not contain
the same version of glibc you compiled this copy of mdadm against.

This all turned up with the homehost= support in mdadm 2.5, and it
arguably does make the static glibc build less useful. (Still,
if you need a static build that works with no glibc present at
all, there's always uClibc.)

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
