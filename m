From: NeilBrown <neilb@suse.de>
Subject: Re: Internal bitmap always 1/1
Date: Wed, 5 Jan 2011 07:28:26 +1100
Message-ID: <20110105072826.1a800804@notabene.brown>
References: <AANLkTin_HZkgTb16Vzwvg93V9P6nm_dM-ZrjUnsKCEk-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin_HZkgTb16Vzwvg93V9P6nm_dM-ZrjUnsKCEk-@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 4 Jan 2011 17:51:17 +0100 Andrea Gelmini <andrea.gelmini@gmail.=
com>
wrote:

> Hi all,
>    and thanks a lot for your effort on MdAdm.
>    With latest git version of mdadm tools=C2=B9 I have
>    problems with creation of internal bitmap. Doing something like th=
is:
>    ./mdadm -Ss;./mdadm --create /dev/md0 --level=3D1 --raid-devices=3D=
2
> --assume-clean --bitmap=3Dinternal /dev/sdb5 missing --auto=3Dmd -e
> 1.2;cat /proc/mdstat
>    mdadm: stopped /dev/md0
>    mdadm: /dev/sdb5 appears to be part of a raid array:
>       level=3Draid1 devices=3D2 ctime=3DTue Jan  4 17:29:06 2011
>    Continue creating array? y
>    mdadm: array /dev/md0 started.
>    Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] [=
raid10]
>    md0 : active raid1 sdb5[0]
>       55777208 blocks super 1.2 [2/1] [U_]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
>=20
>     I always have 1/1 pages (also with different partition sizes: 1G
> as 80G, no differences).

Why do you think that this is a problem???

NeilBrown


>=20
>    I bisected (because official Ubuntu 10.10 MdAdm work well), and
> I've got this:
>=20
> b8ab2a50aba72c7316d92d0fb414167844673136 is the first bad commit
> commit b8ab2a50aba72c7316d92d0fb414167844673136
> Author: NeilBrown <neilb@suse.de>
> Date:   Tue Nov 17 13:15:34 2009 +1100
>=20
>     Set default bitmap-chunksize for internal bitmaps to at least 64M=
eg
>=20
>     A small bitmap-chunksize hurts performance without helping
>     resync speed much - particularly on internal bitmaps.
>=20
>     So set the default to at least 64Meg.
>=20
>     Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> :100644 100644 fb20383a2af65b778da3653ff1b14cbd32cbe320
> 3b6ffa041b0f83f0dcd95e455194d0bc7c249602 M	mdadm.8
> :100644 100644 f9e6a6db262135476cfed766f15bd0f4ec360847
> 955e832dbb977d432f4fbf90c619a2dbb171707d M	super0.c
> :100644 100644 a21e7e3baf8eeeeaf8b9f6a71ed6a833937e846e
> 8678e9f421b9f45eebaf60849729acf471ad7039 M	super1.c
> :040000 040000 c38915f28a038db7bcf2a207f3b60731d5655bea
> fb66f4f76ef1ff31a00aecd69c1232beee15d82e M	tests
>=20
>    Here the bisect log:
> gelma@=E7=A7=BB=E5=8B=95:/tmp/mdadm$ git bisect  log
> git bisect start
> # bad: [a2973b6af235f993b3085cfb51bc50cc6ca38d38] segfault in imsm
> create with wrong arguments
> git bisect bad a2973b6af235f993b3085cfb51bc50cc6ca38d38
> # good: [c04bf2398e49763460c0e04df3130566ced16555] Release 2.6.7.1
> git bisect good c04bf2398e49763460c0e04df3130566ced16555
> # good: [866d136a2f75b751188dfdd490be4d64e6a14d09] Release 2.6.7
> git bisect good 866d136a2f75b751188dfdd490be4d64e6a14d09
> # good: [6c40598f598874d1d4c2c4d0da0c2a9b873d768d] Merge branch
> 'master' into devel-3.0
> git bisect good 6c40598f598874d1d4c2c4d0da0c2a9b873d768d
> # good: [4a997737a14f580e3addfa1db6be005c37e7c0f4] Merge branch
> 'master' into devel-3.1
> git bisect good 4a997737a14f580e3addfa1db6be005c37e7c0f4
> # bad: [ed8fa52f31521b8314859f290c464f77359933a0] mdmon: check select
> a writable pid_dir
> git bisect bad ed8fa52f31521b8314859f290c464f77359933a0
> # skip: [dd9bb2fbed335f69225ea1a3514bd27422288a18] imsm: prune dead
> code in validate_geometry_imsm
> git bisect skip dd9bb2fbed335f69225ea1a3514bd27422288a18
> # bad: [c1e3ab8c1e76f4ae71ab23bcf5e8c2bf8bd3774e] Merge branch
> 'master' of git://github.com/djbw/mdadm
> git bisect bad c1e3ab8c1e76f4ae71ab23bcf5e8c2bf8bd3774e
> # bad: [cd77ac4eafb0460ff6229e9a8dd732f2c4dd42c5] Assemble: fix
> testing of 'verbose' flag.
> git bisect bad cd77ac4eafb0460ff6229e9a8dd732f2c4dd42c5
> # good: [14e5b4d72b4db55e688581d98ec47131554f747c] Grow: data_offset
> is in sectors, offsets[] is in bytes - convert
> git bisect good 14e5b4d72b4db55e688581d98ec47131554f747c
> # good: [7d5c3964ccfaace123f7b75e15d38c2650e013d8] Change default
> metadata from 0.90 to 1.1
> git bisect good 7d5c3964ccfaace123f7b75e15d38c2650e013d8
> # bad: [b42f577a0dbe0b232600478f4a5068b2f63a2684] Improve error
> messages when metadata handler does not support request.
> git bisect bad b42f577a0dbe0b232600478f4a5068b2f63a2684
> # bad: [b8ab2a50aba72c7316d92d0fb414167844673136] Set default
> bitmap-chunksize for internal bitmaps to at least 64Meg
> git bisect bad b8ab2a50aba72c7316d92d0fb414167844673136
> # good: [ff94fb86fd22842c06e8fad08c27a4e365d7834a] Grow: various fixe=
s
> to recent breakages.
> git bisect good ff94fb86fd22842c06e8fad08c27a4e365d7834a
>=20
> Thanks a lot for your work,
> Andrea
>=20
> -----------------------------
> =C2=B9 git://neil.brown.name/mdadm a2973b6af235f993b3085cfb51bc50cc6c=
a38d38

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
