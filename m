From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: RAID5 reconfig
Date: Mon, 20 Jan 2003 01:19:42 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030120001941.GB23750@unthought.net>
References: <000f01c2ae90$3e9c4eb0$6500a8c0@system>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000f01c2ae90$3e9c4eb0$6500a8c0@system>
To: TJ <tjharrel@eagle.fgcu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 28, 2002 at 11:43:25AM -0500, TJ wrote:
> > Use with extreme care:
> > http://unthought.net/raidreconf/index.shtml
>=20
> > Someone posted a success story on this list a few weeks ago using a
> > pretty big RAID5 volume/array.
>=20
> > Marco
>=20
> > PS: Please use the 'Subject' field.
>=20
> Sorry about that.. Please CC me, I don't seem to be getting any feed =
from
> the list.
>=20
> Thanks for the link. I've been reading up on others experiences and
> documentation seems somewhat thin. Does a mini-HOWTO exist anywhere?
> >From what I've read, first raidreconf is used to change the array, t=
hen
> fsck -f is run to check the product, then the file system resize util=
ity
> must be used to change the size of the filesystem on the RAID array. =
Then it
> would probably be a good idea to run fsck -f once more. This should b=
e
> sufficient to add more disks to a RAID 5 array and enlarge the filesy=
stem to
> take advantage of the larger block device. Am I missing anything?

Only that in some scenarios raidreconf fails horribly - this seems to a=
t
least happen if you have hot spares configured.

Make sure you have a good backup.  Please report success/failure to the
list - that is greatly appreciated  :)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
