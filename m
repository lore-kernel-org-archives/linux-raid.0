From: Song Liu <songliubraving@fb.com>
Subject: Re: Fix bad backport to stable v3.16+
Date: Thu, 23 May 2019 18:11:20 +0000
Message-ID: <C62D2B83-3773-42FA-8918-53C31AB56F97@fb.com>
References: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
 <20190523174433.GB29438@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190523174433.GB29438@kroah.com>
Content-Language: en-US
Content-ID: <C1251FEDB522C04F96DCE9A4F6B0936A@namprd15.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon <ncroxon@redhat.com>, "linux@thorsten-knabe.de" <linux@thorsten-knabe.de>
List-Id: linux-raid.ids



> On May 23, 2019, at 10:44 AM, Greg KH <greg@kroah.com> wrote:
>=20
> On Wed, May 22, 2019 at 04:30:33PM +0000, Song Liu wrote:
>> Hi,=20
>>=20
>> As reported by Thorsten Knabe <linux@thorsten-knabe.de>.=20
>>=20
>> commit 4f4fd7c5798b ("Don't jump to compute_result state from check_resu=
lt state") =20
>> was back ported to v3.16+. However, this fix was wrong. =20
>>=20
>> Please back port the following two commits to fix this issue.=20
>>=20
>> commit a25d8c327bb4 ("Revert "Don't jump to compute_result state from ch=
eck_result state"")
>> commit b2176a1dfb51 ("md/raid: raid5 preserve the writeback action after=
 the parity check")
>=20
> Added to 4.4+ for now.
>=20
> thanks,
>=20
> greg k-h

Thanks Greg!!

Song=
