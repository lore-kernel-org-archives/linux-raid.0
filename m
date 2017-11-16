From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 2/2] mdadm: remove journal with "remove-journal"
Date: Thu, 16 Nov 2017 17:55:31 +0000
Message-ID: <DF9BC546-4C44-4468-8780-8782223043D2@fb.com>
References: <63717f4b-5b81-7290-5265-087713f0bd45@nuclearwinter.com>
 <20170831175101.2965834-1-songliubraving@fb.com>
 <24a446c5-18bd-bcfe-02a4-ec569dc572a5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24a446c5-18bd-bcfe-02a4-ec569dc572a5@gmail.com>
Content-Language: en-US
Content-ID: <9F751C06A1D96B44AF53B1B303519A38@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "shli@kernel.org" <shli@kernel.org>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
List-Id: linux-raid.ids


> On Nov 16, 2017, at 9:35 AM, Larkin Lowrey <llowrey@gmail.com> wrote:
>=20
> Is it not possible to permanently remove a journal and return to resync m=
ode?
>=20
> Here's what I tried:
>=20
> #  mdadm --readonly /dev/md124
>=20
> # cat /proc/mdstat
> Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
> md124 : active (read-only) raid5 md123[7] md127p4[15](J) sdp1[13] sdl1[10=
] sdg1[12] sdf1[11] sdo1[14] sdj1[8] sdq1[9] md122[6]
>       62509129728 blocks super 1.2 level 5, 512k chunk, algorithm 2 [9/9]=
 [UUUUUUUUU]
>=20
> # mdadm /dev/md124 --fail /dev/md127p4
> mdadm: set /dev/md127p4 faulty in /dev/md124
>=20
> # mdadm /dev/md124 --remove /dev/md127p4
> mdadm: hot removed /dev/md127p4 from /dev/md124
>=20
> # cat /sys/block/md124/md/consistency_policy
> journal
>=20
> # echo resync > /sys/block/md124/md/consistency_policy
>=20
> # cat /sys/block/md124/md/consistency_policy
> resync

Could you please try the following command here:

echo active > /sys/block/md124/md/array_state


> # mdadm --stop /dev/md124
> mdadm: stopped /dev/md124
>=20
> # mdadm --assemble /dev/md124 /dev/md12[23] /dev/sd[goqpjfl]1
> mdadm: Not safe to assemble with missing or stale journal device, conside=
r --force.
>=20


