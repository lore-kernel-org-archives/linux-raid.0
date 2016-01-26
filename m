From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/RFC/RFT] md: allow resync to go faster when there is competing IO.
Date: Wed, 27 Jan 2016 09:12:23 +1100
Message-ID: <87si1k2do8.fsf@notabene.neil.brown.name>
References: <CAByoP04f6YgzhXn+55iEpg0SrVnK3mUxOuEfp-Hki_mppOBieg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAByoP04f6YgzhXn+55iEpg0SrVnK3mUxOuEfp-Hki_mppOBieg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chien Lee <chienlee@qnap.com>, linux-raid@vger.kernel.org, shli@kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 26 2016, Chien Lee wrote:

> Hello,
>
> Recently we find a bug about this patch (commit No. is
> ac8fa4196d205ac8fff3f8932bddbad4f16e4110 ).
>
> We know that this patch committed after Linux kernel 4.1.x is intended
> to allowing resync to go faster when there is competing IO. However,
> we find the performance of random read on syncing Raid6 will come up
> with a huge drop in this case. The following is our testing detail.
>
> The OS what we choose in our test is CentOS Linux release 7.1.1503
> (Core) and the kernel image will be replaced for testing. In our
> testing result, the 4K random read performance on syncing raid6 in
> Kernel 4.2.8 is much lower than in Kernel 3.19.8. In order to find out
> the root cause, we try to rollback this patch in Kernel 4.2.8, and we
> find the 4K random read performance on syncing Raid6 will be improved
> and go back to as what it should be in Kernel 3.19.8.
>
> Nevertheless, it seems that it will not affect some other read/write
> patterns. In our testing result, the 1M sequential read/write, 4K
> random write performance in Kernel 4.2.8 is performed almost the same
> as in Kernel 3.19.8.
>
> It seems that although this patch increases the resync speed, the
> logic of !is_mddev_idle() cause the sync request wait too short and
> reduce the chance for raid5d to handle the random read I/O.

This has been raised before.
Can you please try the patch at the end of=20

  http://permalink.gmane.org/gmane.linux.raid/51002

and let me know if it makes any difference.  If it isn't sufficient I
will explore further.

Thanks,
NeilBrown


>
>
> Following is our test environment and some testing results:
>
>
> OS: CentOS Linux release 7.1.1503 (Core)
>
> CPU: Intel(R) Xeon(R) CPU E3-1245 v3 @ 3.40GHz
>
> Processor number: 8
>
> Memory: 12GB
>
> fio command:
>
> 1.      (for numjobs=3D64):
>
> fio --filename=3D/dev/md2 --sync=3D0 --direct=3D0 --rw=3Drandread --bs=3D=
4K
> --runtime=3D180 --size=3D50G --name=3Dtest-read --ioengine=3Dlibaio
> --numjobs=3D64 --iodepth=3D1 --group_reporting
>
> 2.      (for numjobs=3D1):
>
> fio --filename=3D/dev/md2 --sync=3D0 --direct=3D0 --rw=3Drandread --bs=3D=
4K
> --runtime=3D180 --size=3D50G --name=3Dtest-read --ioengine=3Dlibaio
> --numjobs=3D1 --iodepth=3D1 --group_reporting
>
>
>
> Here are test results:
>
>
> Part I. SSD (4 x 240GB Intel SSD create Raid6(syncing))
>
>
> a.      4K Random Read, numjobs=3D64
>
>                                              Average Throughput    Averag=
e IOPS
>
> Kernel 3.19.8                                 715937KB/s              178=
984
>
> Kernel 4.2.8                                   489874KB/s              12=
2462
>
> Kernel 4.2.8 Patch Rollback            717377KB/s              179344
>
>
>
> b.      4K Random Read, numjobs=3D1
>
>                                              Average Throughput    Averag=
e IOPS
>
> Kernel 3.19.8                                 32203KB/s                80=
51
>
> Kernel 4.2.8                                  2535.7KB/s                6=
33
>
> Kernel 4.2.8 Patch Rollback            31861KB/s                7965
>
>
>
>
> Part II. HDD (4 x 1TB TOSHIBA HDD create Raid6(syncing))
>
>
> a.      4K Random Read, numjobs=3D64
>
>                                              Average Throughput    Averag=
e IOPS
>
> Kernel 3.19.8                                2976.6KB/s               744
>
> Kernel 4.2.8                                  2915.8KB/s               728
>
> Kernel 4.2.8 Patch Rollback           2973.3KB/s               743
>
>
>
> b.      4K Random Read, numjobs=3D1
>
>                                              Average Throughput    Averag=
e IOPS
>
> Kernel 3.19.8                                481844 B/s                 1=
17
>
> Kernel 4.2.8                                   24718 B/s                 =
  5
>
> Kernel 4.2.8 Patch Rollback           460090 B/s                 112
>
>
>
> Thanks,
>
> --=20
>
> Chien Lee

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWp+9HAAoJEDnsnt1WYoG5zN4P/2CRO8lyUE0xjRo89BwpHXkJ
SNQHq8Mb7QW8xD6heh8LKT2xGeUleoCu+AdTCrTSuC1qhvqK11Zq/022cb/Ecz9l
ST7jmmO8xlMaeR6o+xNZj7My1NjNMhumn5LFpN14TDifPMsuQ++mxshtf8uKO7RY
SSJOyGr6nJi6YQNn/+ygDwledMs7X0ggPT0zPw86v96/GQiW8HvZh3shY+7TXVzD
uoz+zySDPl01CotRIVS78p1OG4tF7BszY/U+jG7twkK8gQh2ROStBA5oERLdYcs2
5+qkQzCI1SUDyOdtVt1U3a4FPLvgl0AJIgHPriPtvmQx8DJtifko2A8EvdLgwwUF
3B9hL1Wg1HyYIwKbBLkYfZwt4xqpDrN4/Tz6hhXrtYUTkzRHkSDbkk3BVMmAh2us
iqSmTSiLM+kjEEGEZRWt6+hKPLhWrpPbsEgJ6okzRMtqKZ6T7XgQuQN7E4+rpqvi
VxnPDUpzCvEvl9jYzf2TZkaimz7P1tEBoxFs0SG1ERQ+QfoqZx13KGCi39Ig4P3m
Db83dtaBLXapT+pV5uOpLSqIsptzI8yC4tlcQK5Qu3J4l4G7mZhmAM8/1A9hGrQg
Sg2Ekd8jNgpuj0xMrMjT2t6KMh0nZGrU65rIObMejXckTCWfyvcNgsZa2TPc2odQ
aw1nw2wo8P+gLiAgAHZy
=hemA
-----END PGP SIGNATURE-----
--=-=-=--
