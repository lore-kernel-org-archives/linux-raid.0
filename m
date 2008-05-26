From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: How to force stopping an array`
Date: Tue, 27 May 2008 01:02:14 +0200
Message-ID: <200805270102.15029.Dexter.Filmore@gmx.de>
References: <200805262343.20626.Dexter.Filmore@gmx.de> <200805270026.12994.Dexter.Filmore@gmx.de> <alpine.DEB.1.10.0805261829160.31108@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0805261829160.31108@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Dienstag, 27. Mai 2008 00:30:26 schrieb Justin Piszcz:
> On Tue, 27 May 2008, Dexter Filmore wrote:
> > Am Dienstag, 27. Mai 2008 00:06:57 schrieb Justin Piszcz:
> >> On Mon, 26 May 2008, Dexter Filmore wrote:
> >>> So I have a filesystem on an array I cannot unmount, hence I cannot
> >>> stop the array.
> >>> Any way to force it?
> >>>
> >>> Dex
> >>
> >> What is using it?
> >>
> >> lsof | grep /mount_point
> >> lsof | grep /dev/mdX
> >
> > A defunct java process that died from a mem heap error. I can't kill the
> > process, not even -9, leaves a <defunct>.
>
> Other than rebooting I am not sure..  You could try making / re-mounting
> it as read-only but if the java process is still reading from the FS it
> probably will not be of any help.
>
> Justin.

Exactly. reboot pretty much deosn't do any good, afterwars the raid resyncs, 
which takes full 7h here.
What happens there anyway? it resyncs, but mdstats say [UUUUU], all fine.

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
