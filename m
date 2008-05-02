From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Fri, 2 May 2008 09:23:13 +0200
Message-ID: <20080502092313.d724b0b1.taeuber@bbaw.de>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
	<18408.36712.100712.499844@notabene.brown>
	<20080428162556.00ee0d72.taeuber@bbaw.de>
	<18458.34575.416075.798546@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18458.34575.416075.798546@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo Neil,

Neil Brown <neilb@suse.de> schrieb:
> If you use version 1.1 or 1.2 metadata, the metadata is stored at the
> start of the device, so it doesn't get lost.  However the metadata ha=
s
> recorded in it the amount of usable space on the device.  When you
> make the device bigger you would need to update this number.
> There is currently no way to update this for an active array.
>=20
> You can stop the array, and the re-assemble it with=20
>    --update=3Ddevicesize
>=20
> this will update the field in the metadata which records the size of
> each device.  You will then be able to grow the array to make use of
> all the space.

this is just all I needed to know. Stopping the array for this short ti=
me is not an issue.

Many thanks!
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
