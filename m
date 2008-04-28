From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Mon, 28 Apr 2008 16:25:56 +0200
Message-ID: <20080428162556.00ee0d72.taeuber@bbaw.de>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
	<18408.36712.100712.499844@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.36712.100712.499844@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo Neil,

Neil Brown <neilb@suse.de> schrieb:
> On Thursday March 13, aia21@cam.ac.uk wrote:
> >=20
> > Is there a better way to do this?  I am hoping someone will tell me=
 to =20
> > use option blah to utility foo that will do this for me without hav=
ing =20
> > to break the mirror twice and resync each time.  (-;
>=20
> Sorry, but no.  This mode of operation was never envisaged for md.
> I would always put the md/raid1 devices below the LVM.

could you write in some short words what in the design prohibits us to =
grow a raid1 on a grown lvm?
We wanted to do the same:


mutliple RAID1 (aoe targets)
on top of
multiple LVMs
on top of
gigantic RAID6


Thanks
Lars
--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
