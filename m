From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Software, Raid 5, Different Size Drives.
Date: Mon, 17 Aug 2009 07:07:20 -0700 (PDT)
Message-ID: <25160.93380.qm@web51307.mail.re2.yahoo.com>
References: <47af6defcf34329212cd18ef65edad38.squirrel@neil.brown.name>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47af6defcf34329212cd18ef65edad38.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Sun, 16/8/09, NeilBrown <neilb@suse.de> wrote:

> From: NeilBrown <neilb@suse.de>
> Subject: Re: Software, Raid 5, Different Size Drives.
> To: Jon@eHardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Sunday, 16 August, 2009, 11:45 PM
> On Sun, August 16, 2009 4:54 am, Jon
> Hardcastle wrote:
> > Hi quick Q.. I have a 6 drive array made up of 4
> 500GB's and 2 750GB's.
> >
> > I know the array will only take on a size based on the
> smallest drive. To
> > that end as I phase drives out based on usage etc I
> replace them with the
> > best value drive I can lay my hands on (upto 1TB~ as i
> have read a raid 5
> > array of drives over that size approx start to cause
> problems with read
> > failures on re-builds - but that is for another
> thread)
> >
> > So my array is currently ~2.5GB with 2x250GB currently
> not in use and I am
> > about to phase out a 500GB and replace with a 1TB. Now
> i have read that
> > you are better of creating a auto detect raid
> partition on the drive and
> > adding that rather than adding the entire drive (so
> sda1 not sda). This is
> > where my question comes in. I have read that 2 1TB(or
> whatever size) can
> > be different block sizes and hence adding a partition
> that is the entire
> > drive can cause problems as these sizes will differ.
>=20
> This was a topic of a recent thread on this list.=A0
> Apparently there is an
> industry standard which sets out exactly how many sectors a
> 1TB or 2TB
> drive should be, and it seems that all drive manufactures
> adhere to this.
>=20
> >
> > Can anyone tell me what truth there is in this? Should
> I actually create a
> > partition=A0 that is always going to be a nice
> multiple size smaller so i
> > can smooth over the bumps?
>=20
> Personally I never create a single partition for an md
> array.=A0 I either
> use the whole drive, or create a number of partitions for
> different
> arrays.=A0 I also avoid in-kernel autodetect.
>=20
> The question of what "best" may well come down to the start
> up scripts
> that your distro uses and any hidden assumptions that might
> be in them...
>=20
> I guess that isn't very helpful though... I can say that
> either approach
> can be made to work fine.=A0 The one issue that you
> particularly need to be
> careful off is the boot sector.=A0 Partitions always
> leave room for a boot
> sector.=A0 If you don't use partitions and you want a
> separate boot sector,
> then v1.2 metadata is the thing to choose....
>=20
>=20
>=20
> >
> > (also anyone know if raid5 to raid 6 native support is
> anywhere near?)
>=20
> Yes. It works with 2.6.30 (or preferrable 2.6.31) and the
> devel-3.1 branch
> from my git tree git://neil.brown.name/mdadm
>=20
> NeilBrown
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

Any idea where i find out this 'industry standard'?

My setup is build on drives that have a partition on them, so the finer=
 points over the pro's and con's of this are moot for me.. until i come=
 to replace the array. Perhaps someone can tell me tho. If I do use a p=
artition on the 1TB drive, and it is is x blocks big. If i add another =
1TB drive that is x +/- 10 blocks in size. Will the array just use the =
size of the smaller and grow accordingly?

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------

Send instant messages to your online friends http://uk.messenger.yahoo.=
com=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
