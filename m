From: Neil Brown <neil@brown.name>
Subject: Re: Change "mv $targetdir/log $logdir/$log" to "cp $targetdir/log $logdir/$log"
Date: Fri, 09 Oct 2015 16:02:11 +1100
Message-ID: <87mvvs4oto.fsf@notabene.neil.brown.name>
References: <1023141143.22094768.1441596507637.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1023141143.22094768.1441596507637.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yi Zhang <yizhan@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Yi Zhang <yizhan@redhat.com> writes:

> Hi Neil
> When I execute mdadm test with --save-logs set, found below error, could =
you help check it?
>
> Error log:
> tests/10ddf-fail-readd... FAILED - see /var/tmp/log-10ddf-fail-readd for =
details
> cp: cannot stat =E2=80=98/var/tmp/log=E2=80=99: No such file or directory
>

Thanks for the report.
I've applied the following which should fix this (and other issues).

Thanks,
NeilBrown

From=20c54f485288b50c90fa289e79fa66ae01e9162a2d Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.com>
Date: Fri, 9 Oct 2015 16:00:59 +1100
Subject: [PATCH] test: don't move $target/log

Recent change to rename $target/log to a more stable name on
error broke --save-logs as $targetdir/log no longer existed to be
copied.

So change it to a 'cp', not a 'mv'.
While we are fixing things, use $_basename instead of calling
`basename` again, and only use "$logdir" if logs were requested.

And make use "see .. for details" has correct file name.

Reported-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.com>

diff --git a/test b/test
index d0a6cb858212..5315ab97dde0 100755
=2D-- a/test
+++ b/test
@@ -17,7 +17,6 @@ then
 fi
=20
 testdir=3D"tests"
=2Dlogdir=3D"$testdir/logs"
 logsave=3D0
 exitonerror=3D1
=20
@@ -317,10 +316,11 @@ do_test() {
       echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3Ddmesg=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D" >> $targ=
etdir/log
       dmesg | tail -n 200 >> $targetdir/log
       if [ $exitonerror =3D=3D 0 ]; then
=2D	  log=3Dlog-`basename $_script`
=2D	  mv $targetdir/log $logdir/$log
+	  cp $targetdir/log $targetdir/log-$_basename
+	  echo "FAILED - see $targetdir/log-$_basename for details"
+      else
+	  echo "FAILED - see $targetdir/log for details"
       fi
=2D      echo "FAILED - see $logdir/$log for details"
       _fail=3D1
     fi
     if [ "$savelogs" =3D=3D "1" ]; then

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWF0pTAAoJEDnsnt1WYoG50/wQAKmB6pI6jNhxqPl3rbJheao+
PU74zse5R5WNFQ3dnegzeoQETi72C9Z1ALMTc6UWoYvWy2CDKr5k6fMebudKe+1n
7fqI1yCfSvsJFNBI2MLcSLcgWI/4lZ0Ji1wKfjW+Y5eMBMR60N2HLIdumFpPOXf3
+iJQsjbYwmjVZFRnb9jBdxMBsfUI5fsE3VV9irLlCrt1oM2F6uvts+z9UoL6nDrg
hEvO1nUXbgcEpAWjYZkj0OlunJv6hoF22NsFzyidT+3mG2BGD1/zjhrB6+jVN8x3
QgX2cTzNfBge7UqmOtLR3gOPDW6W+RrflnQ1Sf8o/ugW7vSrVwkLCcuc9UZoBVHk
MRsJ2upMkLnDN/bMeSrnuJEuxyGbCaovl8T5sBxyHd9ty0hUjVq+pvRlobOCGxI5
YS8hG2P+4mF/a/13GQLuYGmVew37T/hCghTTMRFMP0qx+iYcgxkKGGhr0dpYywiA
fpalfeog47qPSresx023eXlmdu2vQiHMnYDFCAoJh7Yxb5dYbtmDJzGSND5M4LoU
d0GldIivr47AFcuTZxmyow5hGiwZsodo0CWIpTp6FDliUDnAx7m8DN9+CnPW3vv0
LAOTcfVrgypYL4KEE2nxhvNOBTX+J9lglr3uF25xJrt1V/hvFj9wOaXcnTfYwBcf
22H+DmwDvExABz00P5xA
=1vSe
-----END PGP SIGNATURE-----
--=-=-=--
