From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V3 2/2] md-cluster: Protect communication with mutexes
Date: Mon, 30 Nov 2015 11:58:41 +1100
Message-ID: <87mvtw5mm6.fsf@notabene.neil.brown.name>
References: <1448787432-4138-2-git-send-email-gqjiang@suse.com> <1448818989-8280-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448818989-8280-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 30 2015, Guoqing Jiang wrote:

> +#define		MD_CLUSTER_SEND_LOCK			4
> +/* If cluster operations must lock the communication channel,
> + * so as to perform extra operations (and no other operation
> + * is allowed on the MD, such as adding a disk. Token needs
> + * to be locked and held until the operation completes with
> + * a md_update_sb(), which would eventually release the lock.
> + */

This comment has unbalanced parentheses.  How did it even compile :-)

But there is something else that isn't as clear as it could be....

>=20=20
> @@ -970,14 +1019,18 @@ static int add_new_disk(struct mddev *mddev, struc=
t md_rdev *rdev)
>  		ret =3D -ENOENT;
>  	if (ret)
>  		unlock_comm(cinfo);
> -	else
> +	else {
>  		dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
> +		set_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
> +		wake_up(&cinfo->wait);
> +	}

This code suggests that something has caused a metadata update to be
triggered.  i.e. something set MD_CHANGE_DEVS or similar.
That is presumably add_bound_rdev() - which hasn't yet been called, but
while soon after in add_new_disk().

This feels a little bit fragile.  The new code in md-cluster is only
correct if code in add_new_disk does a particular thing.  I guess I'd at
least like to see a comment in add_new_disk() in md-cluster explaining
what will cause MD_CLUSTE_SEND_LOCKED_ALREADY to eventually be cleared.
Maybe it could also schedule the MD_CHANGE_DEVS to be completely certain
that will happen, but that probably isn't necessary.

So I've applied these for now, but if you could fix one comment and add
another that would help.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWW59BAAoJEDnsnt1WYoG5z7kQAIwksTTH4zedsNZOj0M1d40O
KqP2gzz7xpZa3epW9Ve4IitxNI2oCxKwzpurqE/tFnDfRTgNridxrUis6oFaZFtj
8gem3L/6ZLHfI2qIJC7otk+4QGfa8Jari/60fGUIrBOZc+tyrVdWcgFIlOunqsiY
4RLvmKeRe6Kk+t1xdF8iZ5LZGqRpdquENw2GXrD7H+YCDbmQA0taRYA/QlqbjmtH
RUCgf9buP7E32W53HRd2tlYexYe5m10JpkzJxXdPaOZqHX9BYUYeHpeHk7y2VdCS
WDgovKBKB3CUaAmbLzkSwD0iEG6sLZsNzrefNf3cpS0Fpp63o1+C8w2dhl1yxwdd
vOujMTS0rxrppBzlvIlDJS21mhddNmBvk8eVgdUnUtX1sZKGXMpVZjNBl/rSXxHy
Q33gVeiSeKmh2QsjDXiNu6rz8ZNTC7EZMkNglkCuSWaX+owKOk83PuP7pE5NsE9p
J2NeoKjtvJQO/Omq6pFmqzjYQ0+lsVKQpzRyznL+Wmiqx36giGkXmdXKNApipIGn
t3HMeenZc95eJ4qEIiseyIkQBNv7KP1b0XcSienDQGMIpuEuiTaV40OJqoC03tlB
qHS9tE+DkiovzcMtNmau/B/yMSmw5cuagiH+dbcauIwebjJoFDAGSCzBzs9OXz/+
3embGQdqHVg7znkaJvK2
=O4j0
-----END PGP SIGNATURE-----
--=-=-=--
