From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: Invalid superblock on drives in array
Date: Thu, 25 Dec 2003 12:45:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1072374319.3636.6.camel@binkley>
References: <Pine.GSO.4.44L.0312251811450.3919-100000@legolas.mdh.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.44L.0312251811450.3919-100000@legolas.mdh.se>
To: Peter Jonsson <dal01pjn@mds.mdh.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2003-12-25 at 12:27, Peter Jonsson wrote:
> On Thu, 25 Dec 2003, seth vidal wrote:
>=20
> > if this was running on a sparc then you might want to look at:
> >
> > mdadm --update=3Dsparc2.2
>=20
> I wasn't clear enough. I got into problems when I moved the array fro=
m the
> sparc to the PC so I backed up all the data and then I recreated the =
array
> and formatted the drive (ext3) before moving all the data back.
>=20
> But I tried it anyway with this result :

hmm. I bet the drive labels are screwed up. For fun, stop the array,
load up fdisk on one of the disks and type 'o' - that should make new
dos disk labels.

it's something I ran into, but this was a long time ago, so the above
info might be out of date./

so make new drive labels, repartition and recreate the array.

see if that doesn't fix it.

> It had been running for about 1=BD days before something happend. I a=
ctually
> don't have any idea what might have happend. Something is wrong with =
the
> superblocks but I have idea how that happend. Act of God? ;)

migration from sun to pc or possibly general system gremlins.

good luck
-sv


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
