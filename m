From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] Add command line argument parsing to 'test' sript
Date: Wed, 23 May 2012 13:39:32 +1000
Message-ID: <20120523133932.50a6d4d0@notabene.brown>
References: <1337705730-7335-1-git-send-email-Jes.Sorensen@redhat.com>
	<1337705730-7335-3-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QisWKUDy/52YaiQGqSTqR.1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337705730-7335-3-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QisWKUDy/52YaiQGqSTqR.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 May 2012 18:55:30 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> This adds more generic command line argument parsing to the test
> script. It also introduces a couple of new options, while preserving
> the old '<prefix>' and 'setup' arguments. The new options are
> --disable-multipath and --tests=3D<test1>,<test2>,...
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  test |   88 ++++++++++++++++++++++++++++++++++++++++++++++++------------=
-----
>  1 files changed, 65 insertions(+), 23 deletions(-)
>=20
> diff --git a/test b/test
> index 0679983..9428b20 100755
> --- a/test
> +++ b/test
> @@ -8,9 +8,6 @@ then echo >&2 "test: testing can only be done as 'root'."
>  fi
> =20
>  prefix=3D'[0-9][0-9]'
> -if [ -n "$1" ]
> -then prefix=3D$1
> -fi
> =20
>  dir=3D`pwd`
>  mdadm=3D$dir/mdadm
> @@ -94,10 +91,6 @@ ulimit -c unlimited
>  echo 2000 > /proc/sys/dev/raid/speed_limit_max
>  echo 0 > /sys/module/md_mod/parameters/start_ro
> =20
> -if [ " $1" =3D " setup" ]
> -then trap 0 ; exit 0
> -fi
> -
>  # mdadm always adds --quiet, and we want to see any unexpected messages
>  mdadm() {
>      rm -f $targetdir/stderr
> @@ -209,23 +202,72 @@ rotest() {
>    fsck -fn $dev >&2
>  }
> =20
> -for script in tests/$prefix tests/$prefix*[^~]
> -do
> -  if [ -f "$script" ]
> +do_test() {
> +  _script=3D$1
> +  if [ -f "$_script" ]
>    then
> -   rm -f $targetdir/stderr
> -   # stop all arrays, just incase some script left an array active.
> -   $mdadm -Ssq 2> /dev/null
> -   mdadm --zero $devlist 2> /dev/null
> -   mdadm --zero $devlist 2> /dev/null
> -   # source script in a subshell, so it has access to our
> -   # namespace, but cannot change it.
> -   echo -ne "$script... "
> -   if ( set -ex ; . $script )  2> $targetdir/log
> -   then echo "succeeded"
> -   else echo "FAILED - see $targetdir/log for details"
> -       exit 1
> -   fi
> +    rm -f $targetdir/stderr
> +    # stop all arrays, just incase some script left an array active.
> +    $mdadm -Ssq 2> /dev/null
> +    mdadm --zero $devlist 2> /dev/null
> +    mdadm --zero $devlist 2> /dev/null
> +    # source script in a subshell, so it has access to our
> +    # namespace, but cannot change it.
> +    echo -ne "$_script... "
> +    if ( set -ex ; . $_script )  2> $targetdir/log
> +    then echo "succeeded"
> +    else echo "FAILED - see $targetdir/log for details"
> +      exit 1
> +    fi
>    fi
> +}
> +
> +do_help() {
> +  echo "Usage: "
> +  echo " $0 [--tests=3D<test1,test2,..>] [--disable-multipath] [setup] [=
prefix]"
> +}
> +
> +parse_args() {
> +  for i in $*
> +  do
> +    case $i in
> +    [0-9][0-9])

I changed that to
       [0-9]*)
so that I can
   sh test 0
to avoid 10 and 11, or
   sh test 02r1
to just run the raid1 tests from 02.

> +      prefix=3D$i
> +      ;;     =20

I removed the trailing spaces here :-)

But with just those fixes I've applied both patches,
Thanks,
NeilBrown


> +    setup)
> +      echo "mdadm test environment setup"
> +      trap 0; exit 0
> +      ;;
> +    --tests=3D*)
> +      TESTLIST=3D`expr "x$i" : 'x[^=3D]*=3D\(.*\)' | sed -e 's/,/ /g'`
> +      ;;
> +    --disable-multipath)
> +      unset MULTIPATH
> +      ;;
> +    --help)
> +      do_help
> +      exit 0;
> +      ;;
> +    -*)
> +      echo " $0: Unknown argument: $i"
> +      do_help
> +      exit 0;
> +      ;;
> +    esac
>  done
> +}
> +
> +parse_args $@
> +
> +if [ "x$TESTLIST" !=3D "x" ]; then
> +  for script in $TESTLIST
> +  do
> +    do_test tests/$script
> +  done
> +else
> +  for script in tests/$prefix tests/$prefix*[^~]
> +  do
> +    do_test $script
> +  done
> +fi
>  exit 0


--Sig_/QisWKUDy/52YaiQGqSTqR.1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7xb9Dnsnt1WYoG5AQL2XRAAn8uft6eRVNJgr2bnw+qO2Zrm4gSuMYf8
UpcHssdqRXhwb9AdLop59nc+g+h1RRyPp5xtPWBR3uiwE5FiOdFV6RoAOknHNfLF
ZpcFQnpYy1sRYhaxmR1109itVcsGVwA6BtczEb7ofuk1jSwxHDaTWAn4dDJL5zXX
T3uePeMJcxvEMDvM5DPJQtB+jjd2j29Mz4ZGWeCmI/iieGMqMe0dV5ezLOx8xzzC
MN0t0xXkvWzMei4TVO63Ouxc6kG6HNeurLpM37ttxZ+jZelDYzl0JRozS0Eio+eQ
ccME9RuwJC7qJFBxwtdX1iflJ4oAYnKBLZvDmCdDW1VBPnn1iv05+o8Mj8/AW0WN
JVlk+zGKci3SOoAQQvSfPjZGViquqn2s5HPTiUq76RIdK/LcqglaNObWjZQ+YpO1
cPl6+jKaB0lOw8l4C1IK0pCRY94i3zcQL6Ywk41rWpdFM9W/R/9c3m6SYNmZAVJ+
/imfkgBB32yH4cpHZ2BIt95L4WEa2eiV0dMLfK4Qfy0PfUoTtIhvBNCLAsJv6CxO
GF13EvET+bofqyiU69LHWUWQfmhK15+k7BoT2j2qCegYJCAN+ErzpCN8CnPXpgyo
PPs7JPAk8859hw+OLlffvQAKmy3ZKj5hXBuOb6XiDStdmO2cXNXl+bTO1I6UnGzy
Tn1MbplJU6k=
=0SIX
-----END PGP SIGNATURE-----

--Sig_/QisWKUDy/52YaiQGqSTqR.1--
