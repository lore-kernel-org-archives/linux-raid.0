From: Song Liu <songliubraving@fb.com>
Subject: Re: [LSF/MM TOPIC] (again) THP for file systems
Date: Thu, 14 Feb 2019 01:59:55 +0000
Message-ID: <843818E0-C7E8-451E-A5B1-DAF0F120BD5A@fb.com>
References: <77A00946-D70D-469D-963D-4C4EA20AE4FA@fb.com>
 <20190213235959.GX12668@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213235959.GX12668@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <050ED4B99A554F4AACE4A77BAE0F3527@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-raid.ids



> On Feb 13, 2019, at 3:59 PM, Matthew Wilcox <willy@infradead.org> wrote:
>=20
> On Wed, Feb 13, 2019 at 10:00:10PM +0000, Song Liu wrote:
>> I would like to discuss remaining work to bring THP to (non-tmpfs) file =
systems.
>> This topic has been discussed multiple times in previous LSF/MM summits =
[1][2].
>> However, there hasn't been much progress since late 2017 (the latest wor=
k I can
>> find is by Kirill A. Shutemov [3]).
>=20
> ... this was literally just discussed.
>=20
> Feel free to review
> https://lore.kernel.org/lkml/20190212183454.26062-1-willy@infradead.org/
>=20
> with particular reference to the last three paragraphs of
> https://lore.kernel.org/lkml/20190208042448.GB21860@bombadil.infradead.or=
g/

Thanks for the pointers! I will read the patches and related code. =20

>=20
>> Therefore, we would like discuss (for one more time) what is needed to b=
ring
>> THP to file systems like ext4, xfs, btrfs, etc. Once we are aligned on t=
he
>> direction, we are more than happy to commit time and resource to make it=
 happen.
>=20
> I believe the direction is clear.  It needs people to do the work.
> We're critically short of reviewers.  I got precious little review of
> the original XArray work, which made Andrew nervous and delayed its
> integration.  Now I'm getting little review of the followup patches
> to lay the groundwork for filesystems to support larger page sizes.
> I have very little patience for this situation.

I don't feel I am a qualified reviewer for MM patches, yet. But I will=20
try my best to catch up.=20

Thanks again,
Song=
