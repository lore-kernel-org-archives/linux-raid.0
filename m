From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 7/8] md/r5cache: r5c recovery
Date: Wed, 26 Oct 2016 12:18:18 +1100
Message-ID: <871sz3vrfp.fsf@notabene.neil.brown.name>
References: <20161013054944.1038806-1-songliubraving@fb.com> <20161013054944.1038806-8-songliubraving@fb.com> <87vawnwwlq.fsf@notabene.neil.brown.name> <3F2550E2-584B-495F-BD65-F25BC1C18BFC@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F2550E2-584B-495F-BD65-F25BC1C18BFC@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 22 2016, Song Liu wrote:

>>> +	/* stripes only have parity are already flushed to RAID */
>>> +	if (data_count =3D=3D 0)
>>> +		goto out;
>>=20
>> Can you explain why that is?  When were they flushed to the RAID, and
>> how was the parity determined?
>
> It happens like this: say two stripes on journal: 100 and 200. The data (=
D)
> and parity (P) pages are store in journal as:
>
>       --->  D100   D200   P100  P200 ---->  newer data
>
> Before we flush D100, journal_start points as D100. Then we flush D100,=20
> and new journal_start points as D200. Now the system fails, so next=20
> recovery starts from D200. Recovery code will find stripe 100 only has
> parity. This means, stripe 100 is already flushed to raid. so we can igno=
re it.=20

OK, I see.  Thanks.

So the data for the stripe had previously been flushed before the crash
that is currently being recovered from.  It might help to make the time
of the flush more explicit in the comment:

   /* stripes that only have parity must have been flushed
    * before the crash that we are now recovering from, so
    * there is nothing more to recovery.
    */

Something like that.

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYEARaAAoJEDnsnt1WYoG5WRMP/iplz2qk5V3uN6/gVsyTIOKZ
24Wn415m4IiUjZcWa11NDPGJGdEtGIgsWk3lQ5pxesLQgDA4KLbPt7dXiI0DaGu/
1RkvYoZO6nPgQCsy4I8zDbcEzxqtla5ktyXNeqqYa8MfpNVS6/X8go7WopQBbGUe
DpYV1uqJxg0ho7p1GrPXebe71SkQfMF6aN/KB0ukem+kRTx7+IttAJ4sXHa2H3OZ
yCOL2ZuHT1VGmONhRNARBs4gZaC8LZ+ozNfFbu0BOpZA2nRG9U+L6R48h363jhsg
RhtxZwvkqRE/EFX+z83B8uMDrykWMFfkLc2O/HgcWmfulcXu5yNko/5J2hXlJD3Q
fbpwQBDT2AuK/5PMDBD3+fKsPBNsyoTYmuPiQmIzq89IpHUKVKA7194GFg9VBvXu
VaUWNt9DAaMZVmlD+QCQl39WWeT+FmtuAJk80hWIRcw1kouimHS7ommom0fHRvUr
lB2lRpQMn/Lqr/tcc+GGwFjTGeEa2n4MQYwothIKBo6htf4fcsqNF9nxozu4Vvv0
X+05cMmz1IJcHnGtgfFFqFzcNZIxuL17oD0Gs4HYWFIQN+YqQ1yV7kiEU/ufTRdG
XlnHhD+L5vw8+BGOCRfMudoHSzox2IA3ZojatNW4o/AUxEDambq8kCptSOYA+bi1
WkFT1lW4TFw2o8gk/ItE
=IYN4
-----END PGP SIGNATURE-----
--=-=-=--
