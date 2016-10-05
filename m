From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] Fix bus error when accessing MBR partition records
Date: Wed, 05 Oct 2016 13:21:08 +1100
Message-ID: <871szv5yej.fsf@notabene.neil.brown.name>
References: <20160929122838.66975-1-jrtc27@jrtc27.com> <87r37y5qmg.fsf@notabene.neil.brown.name> <CB9B156B-28E1-4EDE-9738-9B03ECC60291@jrtc27.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CB9B156B-28E1-4EDE-9738-9B03ECC60291@jrtc27.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Clarke <jrtc27@jrtc27.com>
Cc: linux-raid@vger.kernel.org, debian-sparc <debian-sparc@lists.debian.org>, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 03 2016, James Clarke wrote:

> Hi Neil,
>
>> On 2 Oct 2016, at 23:32, NeilBrown <neilb@suse.com> wrote:
>>=20
>>> On Thu, Sep 29 2016, James Clarke wrote:
>>>=20
>>> Since the MBR layout only has partition records as 2-byte aligned, the =
32-bit
>>> fields in them are not aligned. Thus, they cannot be accessed on some
>>> architectures (such as SPARC) by using a "struct MBR_part_record *" poi=
nter,
>>> as the compiler can assume that the pointer is properly aligned. Instea=
d, the
>>> records must be accessed by going through the MBR struct itself every t=
ime.
>>=20
>> Weird....
>>=20
>> Can you see if adding "__attribute__((packed))" to struct
>> MBR_part_record also fixes the problem?
>
> That also works. When I wrote the patch initially, I wasn=E2=80=99t sure =
if it was a
> "correct" fix, but having looked into it more I *believe* it is conforman=
t. The
> alignment of a packed struct is 1-byte, so, while the compiler may know t=
hat the
> 32-bit fields are 8-byte aligned within the struct, the pointer to the st=
ruct
> need not be aligned, and so the correct conservative code is generated.
>
>> It seems strange that the compiler lets you take a pointer, but then
>> doesn't use it correctly.  Maybe it is an inconsistency in the types.
>
> Yes, the type doesn=E2=80=99t include the provenance of the pointer, so i=
n general the
> compiler can=E2=80=99t know it came from a packed struct (although in thi=
s case not much
> static analysis would be needed). See [1] and [2].
>
>> I don't necessarily disagree with your fix, but I'd like to understand
>> why the current code is wrong.
>
> Hopefully the links make it clearer.
>
> Regards,
> James
>
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D51628
> [2] https://llvm.org/bugs/show_bug.cgi?id=3D22821

Thanks.

It looks as though the type change I suggested would work, but probably isn=
't
the best solution.
Your patch is probably safest, though adding the __attribute__((packed))
as well wouldn't hurt.

I'll leave it for Jes to decide what exactly to apply, but I can offer
a

  Reviewed-by: NeilBrown <neilb@suse.com>

for you patch.

BTW I tried compiling mdadm with clang to see if my clang was new enough
to give a warning (it isn't) but it found a few other things to give
errors about ... I should post patches.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX9GOUAAoJEDnsnt1WYoG5+wwP/RhCvsAJdbx8F0LmyXGte+Re
nHfwnoVTF7fdRikAAotTyzyEwOLrV/oUKWZjfKfEzGEYL0SfnrG8qxUIqfrj8q7u
vbZiK6vWNYzBSHISH5JUMxaTBJVtGzWITDudwGUSwj/PpSTYhnofgdhFaHe+slVj
m04I9wfnEL6xbuWP2Bv96E3RIdE+ejJku/Bc8dEMdzCJeeDtC26jmWw+QbCLNtnM
EGugZEtub7Kq7EyHeikEeiVpvBSL+TOjE/6Y5sby7E35VBG4iWAaeLqCO2Z3SJ4p
gdFOEwE2TBh9JAMgLPgG6+LumcEne+zr9uzZQVa7f3bm1fNW2inF4rFSpZA5TABu
yuEMh5US0QtHE0+dsU1CHe15krGUs1YfPrYviW1wZW0OlMlg2LDXaPC1SBEiRoeh
tOweHT1tQdsX9orM0qBKG1QgvLABavrMjdV+3+gbPFE/N6S5E5uVQQmvQJOAFvbl
d5FAwzS2u162TC6p9GyKTn4D2TyXhr97Sbp1LuJ5h+CWp1vj/wjM4LU/qJ6OTo/U
icAWCUa1Cr8l29HIIsXkYKxLuzGG+LApStlb2jHcTZUu4SuYnMHB32TcXdPXGZcC
9XJk4V/MQ25MgmnTfiUEsM6koiVTv5J5boAdkrM2dCXhgV8usfJcERBAcCnqpZ7B
bucTIQrGSUXw6hyAy1Ny
=Wbr8
-----END PGP SIGNATURE-----
--=-=-=--
