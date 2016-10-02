From: James Clarke <jrtc27@jrtc27.com>
Subject: Re: [PATCH] Fix bus error when accessing MBR partition records
Date: Mon, 3 Oct 2016 00:00:42 +0100
Message-ID: <CB9B156B-28E1-4EDE-9738-9B03ECC60291@jrtc27.com>
References: <20160929122838.66975-1-jrtc27@jrtc27.com>
 <87r37y5qmg.fsf@notabene.neil.brown.name>
Mime-Version: 1.0 (Mac OS X Mail 10.0 \(3226\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r37y5qmg.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, debian-sparc <debian-sparc@lists.debian.org>
List-Id: linux-raid.ids

Hi Neil,

> On 2 Oct 2016, at 23:32, NeilBrown <neilb@suse.com> wrote:
>=20
>> On Thu, Sep 29 2016, James Clarke wrote:
>>=20
>> Since the MBR layout only has partition records as 2-byte aligned, =
the 32-bit
>> fields in them are not aligned. Thus, they cannot be accessed on some
>> architectures (such as SPARC) by using a "struct MBR_part_record *" =
pointer,
>> as the compiler can assume that the pointer is properly aligned. =
Instead, the
>> records must be accessed by going through the MBR struct itself every =
time.
>=20
> Weird....
>=20
> Can you see if adding "__attribute__((packed))" to struct
> MBR_part_record also fixes the problem?

That also works. When I wrote the patch initially, I wasn=E2=80=99t sure =
if it was a
"correct" fix, but having looked into it more I *believe* it is =
conformant. The
alignment of a packed struct is 1-byte, so, while the compiler may know =
that the
32-bit fields are 8-byte aligned within the struct, the pointer to the =
struct
need not be aligned, and so the correct conservative code is generated.

> It seems strange that the compiler lets you take a pointer, but then
> doesn't use it correctly.  Maybe it is an inconsistency in the types.

Yes, the type doesn=E2=80=99t include the provenance of the pointer, so =
in general the
compiler can=E2=80=99t know it came from a packed struct (although in =
this case not much
static analysis would be needed). See [1] and [2].

> I don't necessarily disagree with your fix, but I'd like to understand
> why the current code is wrong.

Hopefully the links make it clearer.

Regards,
James

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D51628
[2] https://llvm.org/bugs/show_bug.cgi?id=3D22821=
