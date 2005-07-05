From: David Kowis <dkowis@shlrm.org>
Subject: RE: mdadm memory leak?
Date: Tue, 05 Jul 2005 10:56:04 -0500
Message-ID: <20050705105604.pk9cj96u4ggoo000@shlrm.org>
References: <200507050459.j654xlE06886@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_1df472eb2lr4"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200507050459.j654xlE06886@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org, 'Eric Sandall' <eric@sandall.us>
List-Id: linux-raid.ids

This message is in MIME format.

--=_1df472eb2lr4
Content-Type: multipart/signed;
	boundary="=_1cjp2x8g9128";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit

This message is in MIME format and has been PGP signed.

--=_1cjp2x8g9128
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Quoting Guy <bugzilla@watkins-home.com>:

> Run "ipcs" to see if you have shared memory usage that seems wrong, or
> grows.
>
> # ipcs -m
------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status
0x00000000 65536      root      600        33554432   11         dest
0x0052e2c1 98305      postgres  600        10330112   11

> I have none, but I don't have a database.  Databases I have used on other
> systems tend to use a lot of shared memory.
>
> Also, if you were really out of memory, you would have active swapping.
This has happened before. The computer was thrashing so badly, all I could do
was hit ctrl-alt-del and hope it eventually shut down cleanly. Which it did
about an hour later.
>
> It is normal for the buffer cache to use most "unused" memory, so it would
> seem like you have almost none free, but the buffer cache will give up
> memory when needed.  I think you have another problem, not memory related.
> Also, you can stop mdadm from running.  The system will still work, just not
> monitor the arrays.  If you really think it is mdadm related, kill it.  Or
> use "/etc/init.d/mdmonitor stop".  At least as a test.
I think mdadm isn't actually running, so it might be the device mapper stuff
itself. ps -eaf | grep mdadm shows nothing

>
> Run top, look at this line:
> Mem: 515296k av, 508128k used, 7168k free, 0k shrd,  128412k buff
 From my top:
Mem:    773984k total,   765556k used,     8428k free,    65812k buffers
Swap:  2755136k total,        0k used,  2755136k free,   526632k cached

>
> I think buff (128412k) is the amount of "unused" memory.  But not sure.  I
> never had a memory issue with Linux, so have not researched this.  But I
> have on other Unixes.
>
> Guy
>


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


--=_1cjp2x8g9128
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBCyq2UtgErhgxHMHsRAgEpAJ4vdMmaiL6pS7SneAZgcG4bWkTXFgCdFXeH
oHej9jL/7ez/oV82ciR60fg=
=fiqq
-----END PGP SIGNATURE-----

--=_1cjp2x8g9128--

--=_1df472eb2lr4
Content-Type: application/pgp-keys
Content-Description: PGP Public Key
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.0 (MingW32)

mQGiBEH8OdURBAD6e70wUmXpsrobHGKyf6zbag4Wz5r9gMEFhLln+OzCenSgw6tm
Wdl/ek4sIZ1Mz+/T4Y1Mz2xgejvwva5ZjZh5tMKgp6hk65maucGFNeW5zJExRF3x
EAgKt0vdhkXZ3nJ8TkPa1MnX7OfX8fzSerDf6JLPQZ+IhscZrd2oyhFZ4wCgnMwc
1d+4H45hXDRVpgUCJfFLjPMEAI1Vo50iNwzSIS8HtLNjmxhq+r1KUss5bf43wlD9
SY2UC/CBCLD3MYQiaGDq0+J14ZXB0gA/I2t4uooKuvMaJagtnUuq3plERKWyNKfu
4Smuf29baVJea2WlNeme8ZAk4NTKIc0KxRF+vFbN0VFhAfCA7vd7cCUkKz3NLEpS
qHPOA/9xkic/M8HBMNRx8VWFhAqfOEX1CNkziBVlIvkEmrXtISx7yrXvNwqZh+MS
pldF6TtTotGYlUTFYRUf7QcLmbKwzGD7YtaZ70FI8feO1HRnt2beLW5LT9S45PuW
iMe8rx33yf2BFM4cbf7jvPif1zWYaKxEjgx/2gRLI2HsdzL7M7QeRGF2aWQgS293
aXMgPGRrb3dpc0BzaGxybS5vcmc+iGQEExECACQFAkH8OdUCGwMFCQHhM4AGCwkI
BwMCAxUCAwMWAgECHgECF4AACgkQtgErhgxHMHulrgCeP04IGj7OvnJO2zy9CQzM
+slVWK8AnAzPZ+PUT4v2vmGdow2Ba1LZI0r0iEwEEBECAAwFAkH8QiMFgwHhKzIA
CgkQnUQ+0UT6+t/kDQCfZFwYWOU/SQHcJ6zyxML3h9qj3+wAoJXslSzVoO0jpIR/
yIWC7MY0n/ENuQINBEH8Od4QCACdJpRUcqWcOcqT39OHBA28R72LApp5X4U3zyFr
u5lhBt9xSWCix8fwduFYzllRAzd7C8z/vfind1GzI1EmQ5WgmvtuWrPABEzOEpKY
r2iTYo1zkID1zn/DaZsjMlXdf/pqe78qNDSrINT7dLJxeWM7HP96YasOOa9RjnV3
U0WVUa6gu0Gz8zYkDJPOam4xWXxPuvrxRRcQewAVoByi+iHqX++pTaiTdCztebXU
165jtxN4XW21r6XIJRXhCgchcrOK2EXq/TciLBZmN+BGK+SsGTaOvYKhNHwTBEXQ
POBk+DrXdEk1gSnFYApRnBiRauB/hlAFUPGPv6AtH+JbVwLnAAMFB/sEwKgAVAAb
a7sklOo9JdVUMvEPwZfzzVshYi8lVoZDwdPxGqspqV9Q16es6u+wLDuZ8GERmZFB
RmuzAoixO+kWWwek6M2TOlPYWTI0TThRjCrsqdvm/Q9ieOJ5Lmm2D/K460AIwHpc
L45KQIgz9FE7hJTmiPTdXZoN+Q/ZNO2SIpTEhngrOGnBe7EO77200fJ9pgAXkfok
0fq1d+x0zDCZcCEqA4JYs5JbWnbKtICLgRdn+8yQ9PhkozH/my98Tm24tQCvWCru
dgoM7aSTTtW7tMgqWJXgXaWljigtG7YyiAebUvlR51wNjv/kxbIHegprxbDPSIum
QsGy+M/BZb2TiE8EGBECAA8FAkH8Od4CGwwFCQHhM4AACgkQtgErhgxHMHsDRwCb
BNyLozS1TlFWuXZ9wf7CY9e9vckAn0dgJWJUuxPqEnKOMVtXy8l1C5V8
=QKIf
-----END PGP PUBLIC KEY BLOCK-----

--=_1df472eb2lr4--

