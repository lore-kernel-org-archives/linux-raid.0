From: Lukasz Stelmach <l.stelmach@samsung.com>
Subject: Re: [PATCH 16/23] initramfs: simplify clean_rootfs
Date: Thu, 23 Jul 2020 16:25:34 +0200
Message-ID: <dleftjblk6b95t.fsf%l.stelmach@samsung.com>
References: <20200714190427.4332-1-hch@lst.de>
        <20200714190427.4332-17-hch@lst.de>
        <CGME20200717205549eucas1p13fca9a8496836faa71df515524743648@eucas1p1.samsung.com>
        <7f37802c-d8d9-18cd-7394-df51fa785988@samsung.com>
        <20200718100035.GA8856@lst.de> <20200723092200.GA19922@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200723092200.GA19922@lst.de> (Christoph Hellwig's message of
        "Thu, 23 Jul 2020 11:22:00 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-07-23 czw 11:22>, when Christoph Hellwig wrote:
> On Sat, Jul 18, 2020 at 12:00:35PM +0200, Christoph Hellwig wrote:
>> On Fri, Jul 17, 2020 at 10:55:48PM +0200, Marek Szyprowski wrote:
>>> On 14.07.2020 21:04, Christoph Hellwig wrote:
>>>> Just use d_genocide instead of iterating through the root directory
>>>> with cumbersome userspace-like APIs.  This also ensures we actually
>>>> remove files that are not direct children of the root entry, which
>>>> the old code failed to do.
>>>>
>>>> Fixes: df52092f3c97 ("fastboot: remove duplicate unpack_to_rootfs()")
>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>>=20
>>> This patch breaks initrd support ;-(
>>>=20
>>> I use initrd to deploy kernel modules on my test machines. It was
>>> automatically mounted on /initrd. /lib/modules is just a symlink to
>>> /initrd. I know that initrd support is marked as deprecated, but it
>>> would be really nice to give people some time to update their
>>> machines before breaking the stuff.
>>=20
>> Looks like your setup did rely on the /dev/ notes from the built-in
>> initramfs to be preserved.

Our initrd image contains only the modules directory and 5.8.0-rc5-next-202=
00717
in it.

>> Can you comment out the call to d_genocide?  It seems like for your
>> the fact that clean_rootfs didn't actually clean up was a feature and
>> not a bug.
>>=20
>> I guess the old, pre-2008 code also wouldn't have worked for you in
>> that case.
>
> Did you get a chance to try this?

Indeed, commenting out d_genocide() helps.

Kind regards,
=C5=81S

PS. Marek is currently out of office.
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl8Znd4ACgkQsK4enJil
gBCbRwf/a8zcYpq6fg33J7fIlOcoksF9Af2NtQiylKh+dwApPMNMHisMvMZSiqjJ
2e7fkz2A/7RgmFIuZy4INXlKBO1BUKC8iePYl8keZNbpc+r3Tn8dx4+uCFq0zVGZ
CbIcosS97UJ5sdDRvdBPPHISN4ujFnVkSrmvFbFLLRpVF0+RxKpaPLLFc/OHlp9s
KX0vJSICnxsS4sabz/HYURUoRqsMwqo+O/di8aCurcBR/1hVU93ypL0a1KulGx8W
XucamIFSYjMSUjb2/UGxA2wK4OnvY7PRORBFqzc7jnyBFfd3SHnVnUQ8LIqykF/x
VuX6fRL3WIeruj3QAxeYcm0uZaqzXQ==
=uiDC
-----END PGP SIGNATURE-----
--=-=-=--
