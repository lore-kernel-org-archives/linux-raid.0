From: NeilBrown <neilb@suse.de>
Subject: Re: md raid performance with 3-18-rc3
Date: Tue, 25 Nov 2014 13:37:42 +1100
Message-ID: <20141125133742.0154a4d4@notabene.brown>
References: <5472E7DE.5070702@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Vp1RMnDOJ9bPJngpfUGy/cX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5472E7DE.5070702@caviumnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manish Awasthi <manish.awasthi@caviumnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Vp1RMnDOJ9bPJngpfUGy/cX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Nov 2014 13:40:06 +0530 Manish Awasthi
<manish.awasthi@caviumnetworks.com> wrote:

> Hi,
>=20
> We benchmarked the md raid driver performance on 3-18-rc3 kernel and=20
> compared the results with that of 3.6.11. The reason for this exercise=20
> is to understand if multithreaded raid driver has any performance=20
> benefits over 3.6.11 which is single threaded. Here are some details=20
> about the setup

Thanks for doing this!!!! I love it when people report test results.


>=20
> System: Intel(R) Xeon(R) CPU E3-1230 V2 @ 3.30GHz 4 cores (8threads),=20
> 8GB RAM.
> Setup: 3 SSDs create a raid5 array
> test tool: iozone (only read/re-read, write/re-write tested), blocksize:=
=20
> 4k-64k, filesize: 1Gig to 200Gig
>=20
> Comparison was done for speed of data transfer in kBytes/sec and also=20
> the CPU utilization as reported by iozone.
>=20
> raid on 3.18.0-rc3 performed much worse than raid on 3.6.11.
>=20
> Read/Write: raid on 3.18.0-rc3 operated at almost half the speed of raid=
=20
> on 3.6.11

That really isn't very good.... Can you try some of the kernels in between
and see if there was a single point where performance dropped, or if there
were several steps?


>=20
> CPU Utilization: With md raid on 3.18.0-rc3, the CPU utilization was=20
> less than half of md raid on 3.6.11 on WRITE operations. However, for=20
> READ operations, 3.18-0.rc3 had more CPU utilization than 3.6.11.

Can you use "perf" to determine where the extra time is going?

  perf record
  run test
  stop perf
  perf report

or something like that.

>=20
> Also, I noticed that scaling up the CPU cores of the system scales down=20
> the raid througput with 3.18.0-rc3.

This is by writing numbers to "group_thread_cnt" ??? Can you provide a simp=
le
table comparing thread count to throughput?  Or maybe a graph.  I love
graphs :-)


>=20
> I do have detailed logs of the comparison but I'm not sure I should send=
=20
> those on this mailing list.

A few megabytes?  Yes.  100Meg?  No.

If you could put them on a website somewhere that I can browse or download
I'll try to have a look.

>=20
> If my observation aligns with someone else's, then what is really the=20
> gain with multithreaded raid.

Some testing shows real improvements.  Obviously we cannot test everything
and I'm very glad to have extra testing from other people.
If we can quantify the regressions and confirm exactly when they occurred, =
we
can start looking for a solution.

Thanks a lot!

NeilBrown


>=20
> Manish
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Vp1RMnDOJ9bPJngpfUGy/cX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHPrdjnsnt1WYoG5AQLl4Q/+KRVSoosq2+pqk5CZDt+pZ9dzjgfaNuum
L2tpRQW3GbQPD02WqQFHqO7wVrvxIZoP5t56USd+K4fOk1JDGn2NSaeLbUikcEei
LBQJu4j0iAj+LJmvaohHmw/NtxbwGvqaky/iga23mC8rrLGLlB7RMtQK5iAFg1mj
/3XjK5wGhwAYD8lSPBGgBaaiKHOVra3GSjDNAklI2oYvOLZedLC9NPQFlUqXtymw
kLondpEQGsNYYZLg5L4Zg5AAD6mc+JFVukwCeusZMnKc5Xj2V6Y3nuehKRb+fOlb
Pxjc/RYG2L5tAEu6GO8OzINGyArT3patckL31jao1U550N5RprP59bR+mbfTHKIp
RoQN51for9IBI0rIUNFYTBh2zGO6WC9/wO2PH81bdyxuDaqAY+W76EiI+4zeQgJh
y85FEJnf0rd4j4g4o3UIJZm/VeJ2abWXeIwPLxiE5D6SCmTlIv/smS/LV0F0eR6z
MX1xZH+zS6zBpxJvesEA+0+soROmFtKaV0AtUvIBc634Kw9ySxrByH38ptztbMRj
DJRPWcwxoZc3u7kmpMqpUKOhxWysBYz0W7bDdw66/hS9g+7YjOHA/YfrxlzdNNCd
S0P2gHiEPda2cyhIGBt8E/MFxGf5TPO6FUi24Oow8cLyMs9HQ6T6ERsPQAfymedx
NGqtBdG6wns=
=XNsw
-----END PGP SIGNATURE-----

--Sig_/Vp1RMnDOJ9bPJngpfUGy/cX--
