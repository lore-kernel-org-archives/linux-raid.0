From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Fri, 09 Nov 2012 12:35:45 +0100
Message-ID: <1352460945.4387.7.camel@mattotaupa>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Q24RmoYZa30o0Fn5QosQ"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids


--=-Q24RmoYZa30o0Fn5QosQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Jim,


Am Donnerstag, den 08.11.2012, 13:47 -0800 schrieb Jim Kukunas:
> Optimize RAID6 recovery functions to take advantage of
> the 256-bit YMM integer instructions introduced in AVX2.

in my experiencing optimizations always have to be back up by
benchmarks. Could you add those to the commit message please.

> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>

[=E2=80=A6]


Thanks,

Paul

--=-Q24RmoYZa30o0Fn5QosQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlCc6pEACgkQPX1aK2wOHVggMACfebjW0Qn6Eaq0Sw/adM91N97B
wv8AnRkNMQwR5bbpuFVZ7VSd4sWjsrss
=FhLT
-----END PGP SIGNATURE-----

--=-Q24RmoYZa30o0Fn5QosQ--
