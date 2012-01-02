From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Cannot remove failed disk from container
Date: Tue, 3 Jan 2012 10:31:04 +1100
Message-ID: <20120103103104.3f179d73@notabene.brown>
References: <20111229132738.5659.99578.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZljIYvI9ngtki+=bHo6bIw+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111229132738.5659.99578.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/ZljIYvI9ngtki+=bHo6bIw+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Dec 2011 14:27:38 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When disk is failed by mdadm e.g.:
>     mdadm -f /dev/md/raid_array /dev/sdX
> and then it is tried to be removed from container e.g.:
>     mdadm --remove /dev/md/container /dev/sdX
>=20
> mdadm refuses it with information:
>     mdadm: /dev/sdX is still in use, cannot remove.
>=20
> Problem was introduced in commit:
>     monitor: don't unblock a device that isn't blocked.
>     /2011-12-06/
> Disk without unblocking it cannot be really removed from array
> and reference to if is still reported under 'holders' sysfs entry.
>=20
> As this commit is necessary for managing degraded array during
> reshape and rebuild code for unconditional unblocking disk on removal
> is added.
> Guard for setting DS_UNBLOCK during reshape/rebuild avoids process
> performance degradation.

You seem to be addressing the symptom rather than understanding the real
problem.

If a device isn't marked as 'blocked' then it simply doesn't make any sense
to "unblock" it - that cannot do anything useful.

If the commit you identify broke things for you, then we need to understand
exactly why.  What exactly is the problem, how was the code previously
allowing things to work?  What is the minimal thing we need to do to allow
things to work again?

Just setting DS_UNBLOCK because it seems to work but without a clear
justification isn't acceptable.

NeilBrown


>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  monitor.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/monitor.c b/monitor.c
> index 29bde18..ce66625 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -346,6 +346,12 @@ static int read_and_act(struct active_array *a)
>  				a->next_state =3D active;
>  			}
>  			if (a->curr_state > readonly)
> +				/* For disk removal when no md process
> +				 * /e.g. reshape/ is in progress, trigger
> +				 * unconditional device unblock first
> +				 */
> +				if (a->curr_action =3D=3D idle)
> +					mdi->next_state |=3D DS_UNBLOCK;
>  				mdi->next_state |=3D DS_REMOVE;
>  		}
>  	}


--Sig_/ZljIYvI9ngtki+=bHo6bIw+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwI+ODnsnt1WYoG5AQJsyA/9GuQs0Dg+cdovhvfej0+8i0X9wWQ/8jl1
+rCujgOoXkt2sTJDuCFXz5LqrXNVBC3Lfcv9YmgMq9n7VKhKxHTOvAPNEP7tvXGK
U6z5Xt34DQQJjGGQsTEQwUBZR27YAbd00gvsFsI2QyYKGU+tyrTfMpnr6IR2w8s/
XPw54EZMi9WpexkqV/IKlF7bb6YThoCG/3W1PU2TMOu6GFafxpW5uQw+PeeFHnRG
oWMt4VykgJ+rXoLDXLMSWB1RJAEj60VLJQ7C9KJLtGJGN3zaJHedSDHsPaA41UeE
e9oGXiILkAsAgHZF4dWkRW2J03kXSYNqLby1nf60NbYg4cP/HchS/gzk8/GlxOBb
3rZzGviaQ6pN+zPcKyCiAT7A6+WQGZcvnWV7afM1vyDoQYAth3livM2PZbtKfVoD
YWGoV6vg7T2uCbh0jfvNg08lU5xXsNVUWawwdxCIpKtPqlxe9b7BVFUFzNSWTFpQ
bYUNM0pF/grTPzmNPcSVnfC0APssh0lvbfT0EESDvVFt39rtRM4sRT6d93VC46ol
E1mi4Mbv9jEMApGDg1GiU4b8cOupTkwRFxLY/a5tQ6V5uc0Ls1zYn29DDuShNFG1
KTfjUiVHtpPX0O3YHw9EwR6ghgGPugNLf3V2zNUk/gMKjXqzVvhDwiDX4jmb+3Hx
F7IVkHh3/mE=
=9dQP
-----END PGP SIGNATURE-----

--Sig_/ZljIYvI9ngtki+=bHo6bIw+--
