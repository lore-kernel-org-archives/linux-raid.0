From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: scrub was Re: RAID5 Problem - $1000 reward for help
Date: Sun, 17 Sep 2006 14:46:00 +0200
Message-ID: <200609171446.01130.Dexter.Filmore@gmx.de>
References: <20060915090856.GD27597@boom.net> <B7838FAF-BD7D-4581-8E5C-8CB896AA3CC0@develooper.com> <5b170a7d0609170436w18fc6ff3r713284436c394fa7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0609170436w18fc6ff3r713284436c394fa7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Sonntag, 17. September 2006 13:36 schrieben Sie:
> On 9/17/06, Ask Bj=F8rn Hansen <ask@develooper.com> wrote:
> > > It's recommended to use a script to scrub the raid device regular=
ly,
> > > to detect sleeping bad blocks early.
> >
> > What's the best way to do that?  dd the full md device to /dev/null=
?
>
> echo check >/sys/block/md?/md/sync_action
>
> Distros may have cron scripts to do this "right".
>
> And you need a fairly recent kernel.

Does this test stress the discs a lot, like a resync?=20
How long does it take?=20
Can I use it on a mounted array?

--=20
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
