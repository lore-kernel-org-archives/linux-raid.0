From: NeilBrown <neilb@suse.com>
Subject: Re: Inconsistent use of sectors vs 1k-blocks in sysfs and other places
Date: Wed, 21 Dec 2016 11:06:53 +1100
Message-ID: <87h95yrvqa.fsf@notabene.neil.brown.name>
References: <20161217051420.GA29241@oldkitsune.fastquake.com> <87fulkvpgf.fsf@notabene.neil.brown.name> <20161220221430.GA19146@oldkitsune.fastquake.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161220221430.GA19146@oldkitsune.fastquake.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Brooks <john@fastquake.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 21 2016, John Brooks wrote:

> On Mon, Dec 19, 2016 at 09:32:00AM +1100, NeilBrown wrote:
>> The code is right by definition.  As you say, mdadm uses this interface
>> so we cannot change it.
>
> Yep, I expected as much and fully agree.
>
>> >
>> > Somewhat related, suspend_{lo|hi}, resync_{min|max} attributes specify ranges
>> > in sectors, but the documentation does not specify if they are ranges on the
>> > array size or device size. And RAID10 may even handle resync_max differently
>> > from the rest; I didn't look deeply into that but see commit c805cdecea.
>>
>> suspend_{lo|hi} are are array addresses
>> resync_{min|max} are array addresses for RAID1 and RAID10, and they are
>> device-addresses-offset-from-data_offset for RAID1 and RAID456.
>
> Good to know. One question, is it possible for the offset or size to be
> different across disks in the same array? The documentation says that the size
> is "normally" the same as component_size, implying that perhaps it could be
> different.

raid0 and linear are special.
For linear, it is obvious that differently sized devices can be
combined.
For raid0, it is not quite so obvious.  The array is divided into
region.  The first region is striped over all devices.  Then next region
is striped over all devices that are bigger than the smallest, etc.

The offset can be different on all devices.  The size can be only for
raid0 and linear.

>
>> It is bad that the documentation is incorrect and incomplete.  If you we
>> to post a patch which fixed some of it, I'm sure that would be
>> thankfully accepted.
>
> I will see what I can do.
>
>> In theory you could have a RAID1 with an odd number of sectors used in
>> each component, but I doubt that happens in practice.  So you can get
>> the component size in sectors by reading component_size and multiplying
>> by two.
>
> Is that within a realm of possibility worth mentioning in the docs?

Probably not.  I'd have to check the code to see what it actually
allows.
If the kernel allows odd-sized RAID1, we would have to leave it that
way.  But I'd support changing mdadm (if needed) to refuse to create
a RAID1 with an odd number of sectors (or even a size that is not a
multiple of 4K).

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhZx50ACgkQOeye3VZi
gbn2mA//XoA0ejRy2lHaz2tO25U23vd5Ctxn8oLQ56FkS7O8toq8nb467ADWWaNI
9vjuvF0Z+k0qBLWzxExhEYMW0i323uIDRTVPY5733cwhzDdmvBE0aMjcGBgAzMOv
bQ/GarnXkKEK0Ywtegwl9UdKqrMUcvVj5pDXkDisio9hxgh2B7AVOWCVdkq2LcaE
4CUiIEWqxWO2UoMo09gfnw4QySS4I3FE/axPhn7R1Vl+a/2a5r7GS6tcPHBzVAL5
AYciP9xfwqyE+XPk+RmPuZJIrMLGuclaBPp17Ji4G2e5v9Y2Bo9Q50/JgGKjDPgN
guPmyGRvsreZ8em9w9p2lPdrnP0PmlhWbyebg5Noisxp/rk0EFuMkteDLXZ2Em5k
/dzvJxDNxfvsfzUQ3fISLOhsOJvyZNnrjcN9WyrOYEUQTgImDrQktZ/ysK6i8It+
zGinuEILC4ZhPSNgmoB/+yj2Uf5pYBZj/pb0pE2H8Sbtx1+fvOJYn2hMeVfcQfH7
JWJ2ILV06CGdLI2t6OvIbSLCAYZCq42BIp+cgYUNSLQt5UJCTEbSCVrO/iVDf0Yf
tfW3NsihdEvOHvpYoTaq0IziAXCI3fkgvCCSqo1BWsIQLtcJPRy/DsHF4hljy3mH
sU6YKEtKe4d6m4YJQaWAG6GYVB88X+sxmiF6oQuvspWuNUwO8xg=
=zzrd
-----END PGP SIGNATURE-----
--=-=-=--
