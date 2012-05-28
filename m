From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] Add support for saving log files in test script
Date: Mon, 28 May 2012 10:54:55 +1000
Message-ID: <20120528105455.5d4a1211@notabene.brown>
References: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
	<1337959448-5299-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d21ob+QFGJhOIrkDhzoWIRj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337959448-5299-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/d21ob+QFGJhOIrkDhzoWIRj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 May 2012 17:24:05 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> --logdir=3D specifies where to save, if different from default, and
> --save-logs tells test to save all log files.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  test |   42 ++++++++++++++++++++++++++++++++++++------
>  1 files changed, 36 insertions(+), 6 deletions(-)
>=20
> diff --git a/test b/test
> index 7882586..c7eb069 100755
> --- a/test
> +++ b/test
> @@ -16,6 +16,10 @@ then
>     echo >&2 "test: $mdadm isn't usable."
>  fi
> =20
> +testdir=3D"tests"
> +logdir=3D"$testdir/logs"
> +logsave=3D0
> +
>  # Check whether to run multipath tests
>  modprobe multipath 2> /dev/null
>  if grep -s 'Personalities : .*multipath' > /dev/null /proc/mdstat ; then
> @@ -204,6 +208,7 @@ rotest() {
> =20
>  do_test() {
>    _script=3D$1
> +  _basename=3D`basename $_script`
>    if [ -f "$_script" ]
>    then
>      rm -f $targetdir/stderr
> @@ -215,8 +220,17 @@ do_test() {
>      # namespace, but cannot change it.
>      echo -ne "$_script... "
>      if ( set -ex ; . $_script )  2> $targetdir/log
> -    then echo "succeeded"
> -    else echo "FAILED - see $targetdir/log for details"
> +    then
> +      echo "succeeded"
> +      _fail=3D0
> +    else
> +      echo "FAILED - see $targetdir/log for details"
> +      _fail=3D1
> +    fi
> +    if [ "$savelogs" =3D=3D "1" ]; then
> +      cp $targetdir/log $logdir/$_basename.log
> +    fi
> +    if [ "$_fail" =3D=3D "1" ]; then
>        exit 1
>      fi
>    fi
> @@ -224,7 +238,7 @@ do_test() {
> =20
>  do_help() {
>    echo "Usage: "
> -  echo " $0 [--tests=3D<test1,test2,..>] [--disable-multipath] [setup] [=
prefix]"
> +  echo " $0 [--tests=3D<test1,test2,..>] [--disable-multipath] [--logdir=
] [--save-logs] [setup] [prefix]"
>  }
> =20
>  parse_args() {
> @@ -241,6 +255,18 @@ parse_args() {
>      --tests=3D*)
>        TESTLIST=3D`expr "x$i" : 'x[^=3D]*=3D\(.*\)' | sed -e 's/,/ /g'`
>        ;;
> +    --logdir=3D*)
> +      logdir=3D`expr "x$i" : 'x[^=3D]*=3D\(.*\)'`
> +      ;;
> +    --save-logs)
> +      savelogs=3D1
> +      if [ ! -d $logdir ] ; then
> +        mkdir $logdir
> +        if [ $? -ne 0 ] ; then
> +	  exit 1;
> +	fi
> +      fi
> +      ;;
>      --disable-multipath)
>        unset MULTIPATH
>        ;;
> @@ -259,13 +285,17 @@ done
> =20
>  parse_args $@
> =20
> +if [ "$savelogs" =3D=3D "1" ]; then
> +  echo "Saving logs to $logdir"
> +fi
> +
>  if [ "x$TESTLIST" !=3D "x" ]; then
> -  for script in $TESTLIST
> +  for script in $testdir/$TESTLIST

That's not really right, is it?
I fixed it to instead change...

>    do
> -    do_test tests/$script
> +    do_test $script

..this to
       do_text $testdir/$script

and applied.

Thanks,
NeilBrown


>    done
>  else
> -  for script in tests/$prefix tests/$prefix*[^~]
> +  for script in $testdir/$prefix $testdir/$prefix*[^~]
>    do
>      do_test $script
>    done


--Sig_/d21ob+QFGJhOIrkDhzoWIRj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8LM3znsnt1WYoG5AQInkQ/9HAbffxuSzLcGvfB3myXbVa2NQKBldgOl
E322ATdiGM2SL8sgPsKpggak7XlG+CbcJDPShSRe805fLI2qmLJT6XYul7Eq7BKE
YkK+lewWffRB9JGz+SObaRENlf6eda5Apx7WHHqqHuHIxW4k+dVT7Zkt4I6qGAv7
3+UWxTQ69olKqHiXCUcnAO8BhpYdr+6sKldEspXU5S0jVkBeNs7uyr23MqCPHum2
sU6duQ6x78tBKxqC12FH8PjFyrDiwEvLanIncSn3CcDJBFGGvWRqwjAaaZgHIOYH
up8HKIlgh7BvINKFcbGEqT3bwwT1mnl69yVzHH2JC4wn/q7VJ17HJvdnwKSJjoEa
7WyJ7V+1BQkZX5iwuHUIhLMh76Clc7eLE/X4t21iwe773JJ+75EdRzEFkCPTdQ1H
cjE/BoLnuZNJEliN/zDNr6Ijl/e8wbE71yoadaYijeiejDxRvKOFFKViwjgFlIkb
HtHDnx9r8kdpmxZjjxxrglX5GddLdiFMRNVQlPme0WY3JiX5OTa7y3UhZsyWqlXQ
hii1IYgPMG8T3S/tspEBAfGQPv63RGU7KbkpT5BJ9toWT51czQxNUytrI3TK0Bvm
+jFw3yr6kpSXv4RaSgICpGTdevU7ANdJEQsdg3V/NRCtXL6hlh5FFlbfvj9NWjxe
shF7bNk9R6Q=
=+VpW
-----END PGP SIGNATURE-----

--Sig_/d21ob+QFGJhOIrkDhzoWIRj--
