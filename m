From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: migrating from metadata 0.9 to 1.0 before growing?
Date: Thu, 19 Apr 2012 16:20:43 +0200
Message-ID: <20120419162043.84e7d3f4ae3ba003bd42e430@bbaw.de>
References: <20120224113821.c2b14f48bcf7e6809b2cd3a6@bbaw.de>
	<20120229122906.76d08488@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120229122906.76d08488@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Am Wed, 29 Feb 2012 12:29:06 +1100
NeilBrown <neilb@suse.de> schrieb:
> On Fri, 24 Feb 2012 11:38:21 +0100 Lars T=C3=83=E2=82=ACuber <taeuber=
@bbaw.de> wrote:
>=20
> > Hi there.
> >=20
> > I have a RAID6 using disks in an external SATA enclosure.
> > Now I started to exchange the disks with others twice as big as the=
 ones
> > the RAID was originally created with.
> > The RAID uses metadata version 0.9.
> >=20
> > Now I'm thinking about switching to format 1.0 this way:
> >=20
> > * exchange all disks with the bigger ones piece by piece
> >   (-f old -r old -a new)
> > * wait for rebuild of last disk
> > * recreate RAID with --assume-clean and --metadata 1.0 and the same=
 disks
> > in the correct order
> >=20
> > The --grow shouldn't be necessary this way.
> > Then I grow the filesystem.
> >=20
> > Is this precedure possible without data loss?
> > Or is there a way a metadata version migration could be done more e=
asily?
>=20
> Yes, this should work.  There is no better way.

is it possible to change the chunk size while recreating the array to t=
he new
default or do I have to stay with the 64kiB chunk size?

Because changing the chunk size afterwards might not be possible due to=
 the
new chunk size not fitting in the used device size.

Thanks
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
