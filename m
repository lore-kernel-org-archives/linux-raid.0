From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 09/12] raid5-ppl: read PPL signature from IMSM metadata
Date: Thu, 08 Dec 2016 10:27:58 +1100
Message-ID: <87inqv2ubl.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-10-artur.paszkiewicz@intel.com> <871sxk4jj0.fsf@notabene.neil.brown.name> <0e661d59-033e-6797-b5d1-d30cdb04ef11@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0e661d59-033e-6797-b5d1-d30cdb04ef11@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08 2016, Artur Paszkiewicz wrote:

> On 12/07/2016 02:25 AM, NeilBrown wrote:
>> On Tue, Dec 06 2016, Artur Paszkiewicz wrote:
>>=20
>>> The PPL signature is used to determine if the stored PPL is valid for a
>>> given array. With IMSM, the PPL signature should match the
>>> orig_family_num field of the superblock. To avoid passing this value
>>> from userspace, it can be read from the IMSM MPB when initializing the
>>> log.
>>=20
>> It is up to mdadm to determine if the PPL is valid.  It would only tell
>> the kernel that a PPL exists if it is valid...
>
> The kernel also has to know this value because it writes it to the PPL
> header. So yet another sysfs attribute just for this value? How about
> adding a directory similar to "bitmap" to hold all the PPL related
> settings?

There is only one PPL header (per device) - correct?
md can read that header, change the few fields that it knows about, and
write it back out again.  Does it ever need to change the PPL signature?

When a PPL is created, mdadm can write the initial header.

Am I missing something?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhImv4ACgkQOeye3VZi
gbnRrhAArHXLKhvosF9dLaWnG8rB6d2i746ALD8NIjYvpu2Gz/A67qM08MWMSpgH
iGKqeSYR8oywQ5Zsa28NF+ffHQy4Emnx/iS+KihI1P3INycQDk1VSGsuQQTPWnBX
xlfseW59oflrkphQjBxda/1+ON2xX9z8M+7HEE+V3IJB4YqPkAKxrYZ3XU0oZrtr
Ok9AVMGvUcJpJc/HrEecnS6vcMf1DsCzkCx7glUzDL3Ht1sdFK8X0sOajBAULN58
QtEcyTsTHbH6rMyxzj+yF2SLaz+IEKYD1rJBFPi1385zQZt1oDE9nmQLYXuH1xFA
PAQy/xJ3QmrrH2Lmwxn372htzyzp3oWdPcV4oS+eoJMjtM/hGgqr3GDFvGEImK1q
KslYhUTTo2HoqqH+6FV2MQSivPeWmSLTEyE7KGgrad+mtCvOSK/meDTuQJxcRMv5
gaQbwgX2UkvKRgACFbL6JpndzU2b8/XD+Jra0i37zSenqF87Za9vPUnnCwC1mW2F
FyFEN7hRHfGqD4av2Fn6gCorXd9fPIf8Mx/PAPs48XVKrpPnWubiop2R3qi6MONV
ZHP1LM0XGhooqya2c+gtVLnZxGNxrsU5luK/qlfCQcLnqboxGaN2Rtlyd0xXSpD/
3mzzw2Y5evs4l9OHlA0qUh4wqJB29vMmyd23wwRWo2p9cNDFxFE=
=yisi
-----END PGP SIGNATURE-----
--=-=-=--
