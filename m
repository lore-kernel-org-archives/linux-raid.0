From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: How to force stopping an array`
Date: Fri, 30 May 2008 13:18:08 +0200
Message-ID: <200805301318.08463.Dexter.Filmore@gmx.de>
References: <200805262343.20626.Dexter.Filmore@gmx.de> <alpine.DEB.1.10.0805271542240.19633@p34.internal.lan> <18495.24150.151366.956469@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18495.24150.151366.956469@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Freitag, 30. Mai 2008 03:54:30 schrieb Neil Brown:
> On Tuesday May 27, jpiszcz@lucidpixels.com wrote:
> > >>> Exactly. reboot pretty much deosn't do any good, afterwars the raid
> > >>> resyncs,
> > >>> which takes full 7h here.
> > >>
> > >> There shouldn't be a resync.  Presumably nothing is writing to the
> > >> array, and moments after the last write, the array will have been
> > >> flagged as 'clean' and will not require a resync after a reboot.
> >
> >                                               ^^^^^^^^^^^^^^^^^^^^^^
> >
> > His host crashed != reboot so that is the reason for the resync.
>
> If the host crashes will nothing is being written to the array, the
> array would be marked clean, so a resync will still not be required.
> You should only get a resync if the host crashing within 200msecs of
> the last write completing.
>
> NeilBrown

Well, I hoped to ensure this wouldn't happen by the way I reset the box: first 
force sync by alt-sysrq-s, wait a moment, remount in ro by alt-sysrq-u, wait 
again then reboot with alt-sysrq-b.
Maybe the ro-remount failed due to the zombie hogging the fs, wild guess.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
