From: Keld Simonsen <keld@keldix.com>
Subject: Re: RAID10 - Ensure mirrors aren't on same JBOD
Date: Tue, 27 Apr 2010 15:27:52 +0200
Message-ID: <20100427132752.GA17950@rap.rap.dk>
References: <m2h4877c76c1004261144h1019e9afkf05396996ea77a99@mail.gmail.com>
 <406003.10607.qm@web65416.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <406003.10607.qm@web65416.mail.ac4.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Klaassen <clawsoon@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 26, 2010 at 11:57:09AM -0700, Andrew Klaassen wrote:
> --- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com> wrote:
>=20
> > > --- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com>
> > wrote:
> > > However, it doesn't say what happens with a larger
> > > number of drives. =A0I'm looking for the kind of control I
> > > can get with RAID 1+0, where I can specify which drives are
> > > mirrors of each other. =A0Is that possible with RAID10?
> >=20
> > No, not predictably; the only provided guarantee is that
> > the data will
> > /not/ be duplicated on the same block-device (usually
> > drive).=A0 In
> > practice you will quickly be able to determine where a
> > particular
> > version with a given range of input causes data to be
> > stored, but
> > there is no requirement that future versions produce the
> > precise same
> > alignment and offsets.
>=20
> Ah.  So if I want this level of control, I have to sacrifice the adva=
ntages of RAID 10 and go with RAID 1+0.
>=20
> Good to know.  Thanks.


I think you can control the exact layout of copies in raid10 at creatio=
n time for
the raid. How exactly it will play I am not sure - maybe Neil can tell =
us.

Anyway you should be able to use raid10 as one of the components in a r=
aid 1+0 like scenario, eg as
the raid1 part of the raid 1+0.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
