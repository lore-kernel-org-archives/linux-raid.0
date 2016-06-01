From: NeilBrown <nfbrown@novell.com>
Subject: Re: [RFC 4/5] r5cache: write part of r5cache
Date: Thu, 02 Jun 2016 08:37:29 +1000
Message-ID: <87bn3kr0wm.fsf@notabene.neil.brown.name>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com> <1464326983-3798454-5-git-send-email-songliubraving@fb.com> <87zir5r496.fsf@notabene.neil.brown.name> <8FB9AC1E-AB6D-41B2-9411-C924B23FA7AF@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8FB9AC1E-AB6D-41B2-9411-C924B23FA7AF@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Shaohua Li <shli@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, Kernel Team <Kernel-team@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 01 2016, Song Liu wrote:
>>
>>It isn't at all clear to me why you need the extra page.  Could you
>>explain when and why the ->page and the ->orig_page would contain
>>different content and both of the content would be needed?
>>
>
> In prexor, we need read old data from the disk to perform the=20
> substract-xor. In the meanwhile, we need a buffer for the new data.=20
> When there is no write cache, the new data is in the page of bio.=20
> With write cache, however, the bio might be already released.=20
> Therefore, we will need an extra page here: orig_page for new=20
> Cached data, while newly allocated page just hold old data for prexor.=20
>

Ahh, I get it now - thanks.  The fact that you said "page" rather than
"pages" threw me.  I assumed it was a page for the parity block only,
which is wrong.
So I would write:

 For RMW, the code allocates an extra page for each data block being
 updated.  This is stored in r5dev->page and the old data is read into
 it.  Then the prexor calculation subtracts ->page from the parity
 block, and the reconstruct calculation adds the ->orig_page data back
 into the parity block.

Or something like that.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXT2OpAAoJEDnsnt1WYoG5NmAQAK+2VOzbpH/40NcxScUF2ATl
uUJs2raNOsGxhA68dvxqTbLbes/n9juTlUTB69zHqIDmT6YL903NNmlZYwErAcQe
JkTcCJPu62tJ1931YP/ZxloRebaIKYisg2538SE3VFbd27QKzGnadKSi0lN9YZl6
8RCg1TgzSRTfEq7T5j0gFVkC+Cyo6GUiP8VVOG0SDNjfi3/OllMjTKk7BCBj//GJ
AQ2o2No6UZITCF+HqLJ2Rpl7I9yKP1788aewGmDJ019jhO5XUTa2PjFYVCh32q1i
Zmhe6R/HhQgduIzk59Lv+W5ZF0ey2JFO0HPV7mIDZgemwbFGN61MJ2YDScaRhfWh
obFRw+osNBUTg+dbENn+8TGEMhl7gyUKdFGyQJ663aaBo6bXxrXRejEqwItRdRdf
lvZNjqaSZ94kszbnQzSxJ3hNg3KAQQw8GGvIOitiocS/3ARSJIH9BIUsI3V8WEbX
1wmVebM/Yx2CrVIiJc4tFjKO8q6OLND5BPN63DhFZ4ZIeAdTavScviEPGSVX7u+J
RzkovEfTS4mtKaJbA/qsQ1A4IuYVKLwBVbfm2L6SKjBbwICyVAdTZLwCULlUovSS
yLTsj3s2Dw5AqlqUam7idRrDQFDWvzWF6WtQAIgKZKW9C90L8kKcb/otyJMerVLv
hj+0q1ssgFF+mT6nsoE6
=imdY
-----END PGP SIGNATURE-----
--=-=-=--
