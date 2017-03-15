From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 1/2] md/r5cache: improve add-journal
Date: Wed, 15 Mar 2017 23:48:10 +0000
Message-ID: <E9B05880-0C4F-4AAB-B4FF-13C78B7DE535@fb.com>
References: <20170315182816.3627123-1-songliubraving@fb.com>
 <20170315225100.mr4glirjdjx237fq@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170315225100.mr4glirjdjx237fq@kernel.org>
Content-Language: en-US
Content-ID: <4C93C9C13ACE0B45867D6D46D5E3D40E@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids


> On Mar 15, 2017, at 3:51 PM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Wed, Mar 15, 2017 at 11:28:15AM -0700, Song Liu wrote:
>> 1. suspend the array before adding journal, so that we can add journal
>>   when the array is not read-only;
>=20
> we can't call mddev_suspend in raid5d, because there is deadlock.
> raid5_add_disk can be called in raid5d.

I see. I guess we can just require setting read only before adding journal.=
=20

>=20
>> 2. allow recreate journal when existing journal is Faulty. So that we ca=
n
>>   add-journal before removing failed journal.
>=20
> this is weird usage, why don't we remove the failed journal first?

This is really not necessary.=20

I guess we can just drop this patch.=20

Thanks,
Song

