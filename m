From: NeilBrown <neilb@suse.com>
Subject: Re: two small raid5 cache updates
Date: Wed, 09 Dec 2015 09:57:07 +1100
Message-ID: <87egewr1ks.fsf@notabene.neil.brown.name>
References: <1449072399-15360-1-git-send-email-hch@lst.de> <20151203044750.GA3111265@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151203044750.GA3111265@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 03 2015, Shaohua Li wrote:

> On Wed, Dec 02, 2015 at 05:06:37PM +0100, Christoph Hellwig wrote:
>> The first is a trival cleanup, the second a similarly trivial reduction
>> in memory usage.
>
> Looks good, thanks!
>
> Reviewed-by: Shaohua Li <shli@fb.com>

Both applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZ2BDAAoJEDnsnt1WYoG5TXEP/iAezs3ISOAblekKXN0vaI25
IvdMW7m+lTJNvjC+nekrPWfhzaGYimpqfV+E7pvyoZfOYRqwp2jTgY+SaQ155ZkW
0qWNFZj/yFiMtI6Fgi2g7QJrCdO/hlhMydB5BS5c9dPz9oND6zn38Q44KG/87Pml
XtK32Ol+qlzMDyuAvDf2ICH4pbTVXnu5FNxa1yiSKZIV4Yd8qKNNBk2nMZsM8IMV
d3QrV6Ri8pRtePWNQhbK/3RU1nP7C30v3NdCxtipIRtU36ehI2aRotZwjqMlo89m
tpg8Se3/L11ic9u3OdlPC7mxaVxROZ23gHUDDgOFsDjPK0eB2kr+g9pVIPmg5Qzn
XzA9KLbbJyr2f68tpY0SK2CFXs9oqatCNNQ2dSp/fLsG0QPsGmNpVBLKsSPpjCFK
d68VlbHve6Rn99WrLfMT9z4Gwo2+1OJC3+qctFy/t4neC0GjLu8adn/Nmo36H7a2
rcwk/rmaY0mKfIhCzQv1f+WdlxgCZBNDOoNBBvmz2ezYKCI94zj7CaGcXc8ULavA
T+HrbHLVjnwL6CI20j9EUewAh0aJnQsSqgIcBDx+WH0MDEQyfyMlHZhaN0Ao59PA
6Wbomb3byY9V/1LJVXzx5uJiCppDj8E3NphP4COBNbWzHGNCXDdZ+ldDRdI7dQ04
fMi6V7AUNznufmPQjM7m
=JYPZ
-----END PGP SIGNATURE-----
--=-=-=--
