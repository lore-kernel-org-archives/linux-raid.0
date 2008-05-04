From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Mon, 5 May 2008 01:17:29 +0200
Message-ID: <20080504231729.GA31461@rap.rap.dk>
References: <73000.21239.qm@web50212.mail.re2.yahoo.com> <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com> <1209696179.16523.13.camel@localhost> <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com> <1209715763.7827.2.camel@localhost> <20080502102500.GB16198@rap.rap.dk> <481E0726.1030501@harddata.com> <20080504212927.GB20650@rap.rap.dk> <481E3374.4070105@harddata.com> <20080504231016.GA28472@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080504231016.GA28472@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: vger majordomo for lists <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 05, 2008 at 01:10:16AM +0200, Keld J=F8rn Simonsen wrote:
> On Sun, May 04, 2008 at 04:06:44PM -0600, Maurice Hilarius wrote:
> > Keld J=F8rn Simonsen wrote:
> > >..
> > >Hmm, would raid10,n2, or raid10,f2 then have these flaws too?
> > > =20
> > I do not know.
> > I am, however, about to do some testing to find out.
> > Our company routinely was using RAID1 on systems, until we discover=
ed this.
> > With no ability to boot from RAID5 and similar this leaves us in a =
bit=20
> > of a bind.
>=20
> As raid10,n2 is data wise equivalent to RAID1, then grub/lilo should =
be
> able to boot from raid10,n2.=20
>=20
> raid10,n2 should have better performance than RAID10, but raid10,f2

I meant: raid10,n2 should have better performance than RAID1

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
