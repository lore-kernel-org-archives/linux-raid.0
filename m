From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] md/r5cache: flush data in memory during journal device
 failure
Date: Wed, 15 Mar 2017 23:45:47 +0000
Message-ID: <610391BB-CD9F-485D-8396-05EE43C79976@fb.com>
References: <20170313233626.2109293-1-songliubraving@fb.com>
 <20170314175048.rjyaufwgaclsmhdz@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170314175048.rjyaufwgaclsmhdz@kernel.org>
Content-Language: en-US
Content-ID: <E5272707244CA04B88FE1AA1ACB2C262@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, Dan Williams <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>
List-Id: linux-raid.ids


> On Mar 14, 2017, at 10:50 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Mon, Mar 13, 2017 at 04:36:26PM -0700, Song Liu wrote:
>> For the raid456 with writeback cache, when journal device failed during
>> normal operation, it is still possible to persist all data, as all
>> pending data is still in stripe cache. However, the stripe will be
>> marked as fail with s.log_failed. Thus, the write out from stripe cache
>> cannot make progress.
>>=20
>> To unblock the write out in journal failures, this patch allows stripes
>> with data injournal to make progress.
>=20
> what about the parity part? if log failed, we should skip journaling the =
parity.
>=20

Hmm.. I guess we need to check Faulty bit in some functions. Simply checkin=
g=20
log is not NULL is not enough. =20

I will update the patch.=20

Thanks,
Song=
