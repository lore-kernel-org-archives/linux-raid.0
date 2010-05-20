From: Neil Brown <neilb@suse.de>
Subject: Re: Shrink mdadm RAID5 from 6 disks to 5?
Date: Fri, 21 May 2010 08:32:41 +1000
Message-ID: <20100521083241.43755d02@notabene.brown>
References: <AANLkTimSxarJKmCxfOkJZJJULplm0z1pbVKyQpCG6nEw@mail.gmail.com>
	<20100521073433.75a59a99@notabene.brown>
	<AANLkTimn5ieodsVPsZY022b7VAnfFNARyb3sQn2LMp7u@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimn5ieodsVPsZY022b7VAnfFNARyb3sQn2LMp7u@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Keith ." <lukano@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 20 May 2010 15:42:23 -0600
"Keith ." <lukano@gmail.com> wrote:

> Thanks for the quick reply Neil,
>=20
> I tried the suggested syntax, excluding the array-size in order to
> have mdadm give me the value - but it did not.  I also tried grabbing
> the current array size from df, but I got an error about being unable
> to change array size in the same operation.
>=20
> So just to confirm I'm understanding you correctly ;  mdadm -G
> /dev/md127 --raid-devices 5 --backup=3D/root/backup  - should generat=
e
> an error that provides the array-size value?

Yes.
Actually, you do probably need to change the size first:

  mdadm --grow /dev/md127 --array-size=3Dxxxxx
then once you are sure you haven't lost you data, change the number of
devices.

It might help if you ran the commands with "-v" and reported all the
messages generated, and any kernel log messages.
And maybe
  cat /proc/mdstat

just to give us some more context..
Maybe you have a write-intent-bitmap attached to the array.  You cannot
reshape an array with one of those attached.

NeilBron


>=20
> On Thu, May 20, 2010 at 3:34 PM, Neil Brown <neilb@suse.de> wrote:
> > On Thu, 20 May 2010 07:45:23 -0600
> > "Keith ." <lukano@gmail.com> wrote:
> >
> >> Does mdadm 3.1.x not support shrinking the number of disks in a RA=
ID5 array?
> >>
> >> I have successfully converted my 6x1.5tb RAID6 array to a 6x1.5tb
> >> RAID5 array. =C2=A0The issue that I now face is that one of those =
6 drives
> >> is failed / removed, and as a result - the new RAID5 array is down
> >> it's parity drive.
> >>
> >> I knew I was short a disk when I started the process, but I was un=
der
> >> the assumption that mdadm now supported shrinking of RAID5/6 array=
s.
> >> Am I mistaken, or can anyone throw some suggestions at me so I can
> >> give it a try?
> >
> > It should work.
> >
> > =C2=A0mdadm -G /dev/mdX --raid-devices 5 --array-size=3DXXXXX
> > =C2=A0--backup=3D/root/backup-file
> >
> > If you don't give the 'array-size' value mdadm will tell you what i=
t has to
> > be. =C2=A0You need to be sure that all your data is already within =
that space.
> >
> > NeilBrown
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
