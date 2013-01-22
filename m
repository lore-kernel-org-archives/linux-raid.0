From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Add support for launching mdmon via systemctl
 instead of fork/exec
Date: Tue, 22 Jan 2013 16:46:23 +1100
Message-ID: <20130122164623.1962171b@notabene.brown>
References: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
	<1358774578-2183-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6._PwN8xiRFhK5a4Ujo8wyX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358774578-2183-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

--Sig_/6._PwN8xiRFhK5a4Ujo8wyX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Jan 2013 14:22:56 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> To launch mdmon via systemctl, a new command line argument is added to
> mdadm '--systemctl'. Alternatively it is possible to set the
> environment variable MDMON_SYSTEMCTL.
>=20
> This allows for having mdmon launched via systemctl which avoids
> problems with it getting killed by systemd due to it ending up in the
> parent's cgroup (udev).
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks Jes.  This is certainly something that we want in some form.
Some issues:

 - I have come to the conclusion that --offroot is a bad idea.  We should
   just make that the default.  No matter whether the array is providing the
   root filesystem or not, I never want systemd (or anything else) to kill
   mdmon.  I want it to remain in control.  So the systemctl handling should
   assume offroot. e.g. there should only be one .service file.

 - on my machine (openSUSE), systemctl is in /bin, not /usr/bin.
   Would I be correct in thinking that on your machine, /bin is a symlink
   to /usr/bin?  If so, maybe we can just use "/bin/systemctl"?  If not,
   we might need to try a few different options.
   Similarly I have mdmon in /sbin, not /usr/sbin.  We we cannot all
   use /sbin, we might need to 'sed' the .service file on installation to
   match the current system.
   (I note that you didn't get Makefile to install the .services files.  I
   think we want it to - at least optionally)

 - I want the default behaviour to "do the right thing" in most case, but it
   should be possible  to over-rid (by command line option or env var or
   both).
   So I think I would like it to try systemctl and if that fails for some
   reason (either because the binary doesn't exist, or because it finds that
   the .services file doesn't exist), then it should try to exec mdmon
   directly.
   This default could be over-ridden to always run mdmon directly.

Thanks!
NeilBrown



> +++ b/mdmon.c
> @@ -188,7 +188,9 @@ static void try_kill_monitor(pid_t pid, char *devname=
, int sock)
>  	 * might be "@dmon"
>  	 */
>  	if (n < 0 || !(strstr(buf, "mdmon") ||
> -		       strstr(buf, "@dmon")))
> +		       strstr(buf, "@dmon") ||
> +		       strstr(buf, "/usr/sbin/mdmon") ||
> +		       strstr(buf, "@usr/sbin/mdmon")))
>  		return;

As we are using "strstr", here, the second two cases will be matched by the
first case, so this change is unnecessary.


> =20
>  	kill(pid, SIGTERM);
> diff --git a/util.c b/util.c
> index 6c10365..500b2bd 100644
> --- a/util.c
> +++ b/util.c
> @@ -33,6 +33,7 @@
>  #include	<signal.h>
> =20
>  int __offroot;
> +int __mdmon_systemctl;
> =20
>  /*
>   * following taken from linux/blkpg.h because they aren't
> @@ -1651,6 +1652,9 @@ int start_mdmon(int devnum)
>  	if (check_env("MDADM_NO_MDMON"))
>  		return 0;
> =20
> +	if (check_env("MDMON_SYSTEMCTL"))
> +		__mdmon_systemctl =3D 1;
> +
>  	len =3D readlink("/proc/self/exe", pathbuf, sizeof(pathbuf)-1);
>  	if (len > 0) {
>  		char *sl;
> @@ -1674,18 +1678,33 @@ int start_mdmon(int devnum)
>  			else
>  				skipped =3D 0;
> =20
> -		for (i =3D 0; paths[i]; i++)
> -			if (paths[i][0]) {
> -				if (__offroot) {
> -					execl(paths[i], "mdmon", "--offroot",
> -					      devnum2devname(devnum),
> -					      NULL);
> -				} else {
> -					execl(paths[i], "mdmon",
> -					      devnum2devname(devnum),
> -					      NULL);
> -				}
> +		if (__mdmon_systemctl) {
> +			if (__offroot) {
> +				snprintf(pathbuf, 40, "mdmon-offroot@%s.service",
> +					 devnum2devname(devnum));
> +				execl("/usr/bin/systemctl", "systemctl",
> +				      "start", pathbuf, NULL);
> +			} else {
> +				snprintf(pathbuf, 30, "mdmon@%s.service",
> +					 devnum2devname(devnum));
> +				execl("/usr/bin/systemctl", "systemctl",
> +				      "start", pathbuf, NULL);
>  			}
> +		} else {
> +			for (i =3D 0; paths[i]; i++)
> +				if (paths[i][0]) {
> +					if (__offroot) {
> +						execl(paths[i], "mdmon",
> +						      "--offroot",
> +						      devnum2devname(devnum),
> +						      NULL);
> +					} else {
> +						execl(paths[i], "mdmon",
> +						      devnum2devname(devnum),
> +						      NULL);
> +					}
> +				}
> +		}
>  		exit(1);
>  	case -1: pr_err("cannot run mdmon. "
>  			 "Array remains readonly\n");


--Sig_/6._PwN8xiRFhK5a4Ujo8wyX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUP4nrznsnt1WYoG5AQIr6BAApoKkdxkDyg37BSAvjduS2YG8o++DJixh
75G586n4Ldq1d5eX1IssVLV+W00sE2wXMIIhzOB4f+6myKVjk2Cnk+kzym1vhsXN
QHmxnCcT3IX/rFlvb+dw6AnVsUL7zfj+7ravZDoglOCAk69TD1UZgt1bibZSlpO0
ISbBcHi092rO7o68wZKSefYUIUxomUvoHfWWjzvcPsb62R2XB1bF+uGwtLPtVjW6
ptSi7ZrtEapO+fcZy5mHSPmHSAIQhoTzY1W1KpoNqT14tQ/vaTfAyF4pdtBBr7u4
7AbrNYOIOFZviSi1vuks196eaM1QeOjoZUlAq5rC6knjjYP0jpC11my2VbvvNehX
SU7fmFL5mNPKUfEr84yNZg3APpT0R7V0hV5ir7kcKlJ/qp3Z2Ph1/W6XHqU+dmJG
6dleb4lya5mia1kzpCBIjnlgmfGiFefZEccFj/aj30nlDWjgBgZlNkcHuxAFiQAU
+//dGw14tY4jBrlM+/bwZ8bguoNcB6m83+cKM7GM1+8N9YkD9k5sg6X7lcHY01R2
P8x198qpKYlsd+9qhpRqg/HlJRL95p1/0FaJTPqPKXpnMmpAn8nKZq28OQsInoTw
YVKp/bjLiRubPtpwWhc8KlP+J4oxVUQ9MquWqzHjB/PYWi57LhDUqM3oia44chwI
XXiMtFo6nYc=
=ZRd6
-----END PGP SIGNATURE-----

--Sig_/6._PwN8xiRFhK5a4Ujo8wyX--
