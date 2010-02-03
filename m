From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: If your using large Sata drives in raid 5/6 ....
Date: Wed, 03 Feb 2010 20:27:40 +1100
Message-ID: <1831dfc0b72e282d0a17e24c959c8abe@localhost>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com> <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Numbers are a funny game.

Sure, there is a 1000x increase in the chance of an error occurring
*somewhere* on the drive - as we have 1000x more space. What you need t=
o
keep in perspective is that although building a 2Tb RAID5 from 3 x 1Tb
drives may seem more likely to have problems than a 2Gb RAID5 from 3 x =
1Gb
drives - however if you build a 2Tb RAID5 from 1Gb drives then you woul=
d
probably increase the likelihood of a failure to around the same levels=
=2E

=46rom what I read of the article, it seems like more of a sales pitch =
and
although it has what seem to be good points, they seem to ignore the fa=
ct
of scaling. ie which is more likely to fail horribly, 3 x 1Tb drives or
3000 x 1Gb drives or even 300 x 10Gb drives?

Data storage always seems to be a minefield of misinformation and sales
pitches masked as information - however the best practice is to use RAI=
D to
hopefully minimise downtime if a drive fails, but keep a copy of your d=
ata
elsewhere that you have easy access to if you need it. After this, it
doesn't really matter if you have a single drive failure - or even a do=
uble
drive failure in the case of RAID6.

If you have more failures and the array crashes horribly, then theres n=
ot
much you can do but rebuild and restore.

On Tue, 2 Feb 2010 17:46:25 -0500, Greg Freemyer <greg.freemyer@gmail.c=
om>
wrote:
> All,
>=20
> I think the below is accurate, but please cmiiw or misunderstand.
>=20
> =3D=3D=3D
> If your using normal big drives (1TB, etc.) in a raid-5 array, the
> general consensus of this list is that it is a bad idea. =C2=A0The re=
ason
being
> that the sector error rate for a bad sector has not changed with
> increasing density.
>=20
> So in the days of 1GB drives, the likelihood of a undetected /
> repaired bad sector was actually pretty low for the drive as whole.
> But for today's 1TB drives, the odds are 1000x worse. =C2=A0ie. 1000x=
 more
> sectors with the same basic failure rate per sector.
>=20
> So a raid-5 composed of 1TB drives is 1000x more likely to be unable
> to rebuild itself after a drive failure than a raid-5 built from 1 GB
> drives of yesteryear. =C2=A0Thus the current recommendation is to use=
 raid
> 6 with high density drives.
>=20
> The good news is that Western Digital is apparently introducing a new
> series of drives with an error rate "2 orders of magnitude" better
> than the current generation.
>=20
> See <http://www.anandtech.com/storage/showdoc.aspx?i=3D3691&p=3D1>
>=20
> The whole article is good, but this paragraph is what really got my
> attention:
>=20
> "From a numbers perspective, Western Digital estimates that the use o=
f
> 4K sectors will give them an immediate 7%-11% increase in format
> efficiency. ECC burst error correction stands to improve by 50%, and
> the overall error rate capability improves by 2 orders of magnitude.
> In theory these reliability benefits should immediately apply to all
> 4K sector drives (making the Advanced Format drives more reliable tha=
n
> regular drives), but Western Digital is not pushing that idea at this
> time."
>=20
> So maybe raid-5 will once again be a reasonable choice again in the
> future.
>=20
> (I think these drives may already be available at least as
> engineering samples.  Basic linux kernel support went in summer 2009 =
I
> believe. I believe 2.6.33 will be the first kernel to have been teste=
d
> with these new class of drives.)
>=20
> I don't know if there is a mdraid wiki, but if so and someone wants t=
o
> post the above there, please do.
>=20
> Greg
> --
> Greg Freemyer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Steven Haigh
=20
Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
=46ax: (03) 8338 0299
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
