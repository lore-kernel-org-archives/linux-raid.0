From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 10:06:03 +0100
Message-ID: <20110204090602.GA4017@www2.open-std.org>
References: <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4BB87A.30800@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 04, 2011 at 02:27:38AM -0600, Stan Hoeppner wrote:
> Keld J=F8rn Simonsen put forth on 2/4/2011 1:06 AM:
>=20
> > Well RAID1+0 is not the best combination available. I would argue t=
hat
> > raid10,f2 is significantly better in a number of areas.
>=20
> I'd guess Linux software RAID would be lucky to have 1% of RAID deplo=
yments
> worldwide--very lucky.  The other 99%+ are HBA RAID or SAN/NAS "appli=
ances" most
> often using custom embedded RTOS with the RAID code written in assemb=
ler,
> especially in the case of the HBAs.  For everything not Linux mdraid,=
 RAID 10
> (aka 1+0) is king of the hill, and has been for 15 years+

Yes, you are right, Linux MD really has an advantage here:-)

> >> Something smells bad here.  Does one of the RAID companies own a p=
atent or
> >> trademark on "RAID 10"?  I'll look into this.  It just doesn't mak=
e any sense
> >> for RAID 10 to be omitted from the SNIA DDF but to be referenced i=
n the manner
> >> it is.
> >=20
> > It looks like they do define all major basic RAID disk layouts. (ex=
cept
> > raid10,f2 of cause) . RAID1+0 is a derived format, maybe that is ou=
t of
> > scope of the DDF standard.
>=20
> "A secondary virtual disk is a VD configured using hybrid RAID levels=
 like
> RAID10 or RAID50. Its elements are BVDs."
>=20
> So apparently their Disk Data Format specification doesn't include hy=
brid RAID
> levels.  This makes sense, as the _on disk_ layout of RAID 10 is iden=
tical to
> RAID 1.

Yes, raid10 is just a variation of RAID1, actually raid10,n2 is
identical on the disk to RAID1, eg for a 2 drive or 4-drive array.

> We apparently need to be looking for other SNIA documents to find the=
ir
> definition of RAID 10.  That is what started us down this tunnel isn'=
t it?
> We're so deep now there's no light and I can't see the path behind me=
 anymore. ;)

I dont think SNIA defines RAID 10, which is a specific Linux MD thing.

=46or RAID1+0, I think it is covered by the DDF standard, as what DDF i=
s
aimed at is defining formats on the disks to portably handle RAID. That
means that you can move a set of disks used in one manufacturer's=20
configuration  to another make's  configuration, and it will still work=
=2E

And it will also work with RAID1+0, as the underlying RAID1 and RAID0
formats are defined in DDF. So no need to add specific RAID1+0
definitions. Also RAID1 may mean different layouts, like the "far" and
"offset" layouts, and it would mean an explosion of definitions of
RAID1+0 if you should name and standardize all of these variations of
RAID1+0 explicitely.

best regards
keld

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
