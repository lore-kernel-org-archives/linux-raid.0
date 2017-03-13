From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] md/r5cache: fix set_syndrome_sources()
Date: Mon, 13 Mar 2017 21:20:59 +0000
Message-ID: <C7DCEC37-184E-4633-902A-FF40C347A20A@fb.com>
References: <20170313204435.1732089-1-songliubraving@fb.com>
 <CAPcyv4h6XBdDRrq5+cs9v70v93sHnkTUoFrKuN_-Ox_wjJvvkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4h6XBdDRrq5+cs9v70v93sHnkTUoFrKuN_-Ox_wjJvvkw@mail.gmail.com>
Content-Language: en-US
Content-ID: <CB9A0ED55B626A439C55FD67B4460229@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids


> On Mar 13, 2017, at 1:58 PM, Dan Williams <dan.j.williams@intel.com> wrot=
e:
>=20
> On Mon, Mar 13, 2017 at 1:44 PM, Song Liu <songliubraving@fb.com> wrote:
>> With srctype =3D=3D SYNDROME_SRC_WRITTEN, we need include both
>> dev with non-null ->written and dev with R5_InJournal.
>>=20
>=20
> Can you say a bit more about what this fixes? How does this bug
> manifest itself (user visible effect), and should this be marked for
> -stable?

Before this patch, device InJournal will be included in prexor=20
(SYNDROME_SRC_WANT_DRAIN) but not in reconstruct (SYNDROME_SRC_WRITTEN).=20
So it will break parity.=20

This fixes logic in 1e6d690b9334b7e1b31d25fd8d93e980e449a5f9.=20

Thanks,
Song
