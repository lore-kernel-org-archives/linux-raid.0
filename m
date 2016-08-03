From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] MD: hold mddev lock for md-cluster receive thread
Date: Wed, 03 Aug 2016 10:09:26 +1000
Message-ID: <87shumpvbd.fsf@notabene.neil.brown.name>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com> <7763e508fb97d44bd61e826912055617b8be2c2d.1469922791.git.shli@fb.com> <579F0AA3.5090806@suse.com> <20160801214522.GA129828@kernel.org> <57A06D69.2040703@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57A06D69.2040703@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02 2016, Guoqing Jiang wrote:
>
>> Does it work if we move the mddev lock to
>> process_recvd_msg?
>
> I tried that, but It still have lock issue, eg, when node B and C have=20
> status
> as "resync=3DPENDING", then try to stop the resyncing array in node A.
>

Maybe the reconfig_mutex locking needs to go down in
process_suspend_info() ?? That is the only part that calls quiesce.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXoTY2AAoJEDnsnt1WYoG5xmwQALCugXkXv91HJ9JuxZSViurQ
VxMqYo2/Hstd0apPuqPy6fBCbzigcW70uAZa+OZxQ4BZpYS5NeAe0yBr/86It4bZ
KLtROj/hSA80yBEWmW9mzNxTnPyBjaSk2odVW96uLgZR2KxDw7FW5O+39Hh/cnon
iRrTWKDtap/QWOa7y42M+rAIjjk7WxcAnC/3v32LFLghjK8OUrjQRxZR8nMD4umF
9q+M1msBY+LHZ+6ClFtbndQd4pj9JoXG7XU1ER79Dw40K1uOc7A4/fH1LDHDohLF
oMlzDp44fjtL33T+NNTjLFSs/IrffxCkOtaS5p62BiTXx6y61t7bm4QmR4S7mVNo
DChy88r1cGE4aELGCqXomdC9NCndruycceA3isW7EmNKxhdFtinJEIrNgX8AXQqR
C4xj8/JTwfCpxlCeSj7cxx4BbeN27KL5TBqFTaLuyG8TquhKxJbHrFbUmGLh3u7N
EDO3eaV0PJavtAOOxwHyMvUz6aZeMG0HK8HVKfH8x+VtI8nC5awaEcWoeeKdcE7h
StIL7vScpB/oSKjH0bcrvUNOpD1KotHd0JrK8+whBfZNNkMIXCA94Q20U1kI/T9a
PioAI1zney6kceaARxFZCBufTdlEWfXsGzVcLnVQ6UONSuJMFCz/ZZ8us2MqAm0G
CchbENuqbZORljNxv0Gi
=eDzi
-----END PGP SIGNATURE-----
--=-=-=--
