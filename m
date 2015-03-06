From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Re: Raid 10 Issue [SOLVED]
Date: Fri, 6 Mar 2015 10:32:47 +0100 (CET)
Message-ID: <545546757.7143.1425634367091.JavaMail.open-xchange@app04.ox.hosteurope.de>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de> <20150306085407.GA32079@cthulhu.home.robinhill.me.uk>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150306085407.GA32079@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> Robin Hill <robin@robinhill.me.uk> hat am 6. M=C3=A4rz 2015 um 09:54 =
geschrieben:
>
>
> On Thu Mar 05, 2015 at 06:56:00PM +0100, Stefan Lamby wrote:
>
> > Hello List.
> >
> > I was setting up a new machine using ubuntu 14.04.02 lts using its
> > installer,
> > configuring a raid 10 with 2 disks and lvm on top of it. I was usin=
g 2 disks
> > and
> > now I like to add 2 more disks to the array so i want to end up wit=
h 4
> > disks, no
> > spare.
> >
> > Searching the internet I found that I am not able to --grow the arr=
ay with
> > the
> > mdadm version this ubuntu is using (v3.2.5).
> > Is that right?
> >
> > So I decided to build a new array that way and try to move my data
> > afterwards,
> > which failed:
> > (Is it OK to do it that way or do you recommend another?)
> >
> > root@kvm15:~# mdadm --verbose --create --level=3D10 --raid-devices=3D=
4 /dev/md10
> > missing missing /dev/sdc1 /dev/sdd1
> > mdadm: layout defaults to n2
> > mdadm: layout defaults to n2
> > mdadm: chunk size defaults to 512K
> > mdadm: /dev/sdc1 appears to be part of a raid array:
> > level=3Draid10 devices=3D4 ctime=3DFri Feb 27 15:49:14 2015
> > mdadm: /dev/sdd1 appears to be part of a raid array:
> > level=3Draid10 devices=3D4 ctime=3DFri Feb 27 15:49:14 2015
> > mdadm: size set to 1904165376K
> > Continue creating array? y
> > mdadm: Defaulting to version 1.2 metadata
> > mdadm: RUN_ARRAY failed: Input/output error
> > <<<<<<<<<<<<<<<<<<<<<<<<<<<
> > root@kvm15:~#
> >
> IIRC, in a RAID10 setup, the redundant pair is held on adjacent drive=
s.
> You've specified two adjacent drives as missing, so the array cannot =
be
> run. Try doing:
> mdadm --verbose --create --level=3D10 --raid-devices=3D4 /dev/md10 \
> missing /dev/sdc1 missing /dev/sdd1
>

Dang!
One shot one catch, thank you so much!

Dear Maintainer,
please take a one-to-one copy of Robins explaination and print it if an=
other
dumb user like me tries to do the same and is caught also. This could h=
elp avoid
a lot of frustration. There are posts in the internet which claim the o=
rder of
the given devices is critical.

Thank you all for taking the time to help.
Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
