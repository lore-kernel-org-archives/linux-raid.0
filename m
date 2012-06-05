From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V1] md:Fix name of raid thread when raid takeovered.
Date: Tue, 5 Jun 2012 15:48:51 +1000
Message-ID: <20120605154851.0664f8fb@notabene.brown>
References: <201206051337125784360@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/W.yWAdzGZ05/GF1u3KQybIN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206051337125784360@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/W.yWAdzGZ05/GF1u3KQybIN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Jun 2012 13:37:15 +0800 majianpeng <majianpeng@gmail.com> wrote:

> When raid takeovered, it used old personality to set task->comm[].
> So we add judgement and set corrected task->comm[].
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1c2f904..6b3ce6e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6738,11 +6738,25 @@ struct md_thread *md_register_thread(void (*run) =
(struct mddev *), struct mddev
>  				 const char *name)
>  {
>  	struct md_thread *thread;
> +	struct md_personality *pers =3D NULL;
> =20
>  	thread =3D kzalloc(sizeof(struct md_thread), GFP_KERNEL);
>  	if (!thread)
>  		return NULL;
> =20
> +	/*
> +	 *When raid takeovered,the mddev->pers was old,so the
> +	 *thread_name is wrong.
> +	 */
> +	if (name =3D=3D NULL && mddev->level !=3D mddev->new_level) {
> +		spin_lock(&pers_lock);
> +		list_for_each_entry(pers, &pers_list, list)
> +			if (pers->level =3D=3D mddev->new_level) {
> +				name =3D pers->name;
> +				break;
> +			}
> +		spin_unlock(&pers_lock);
> +	}
>  	init_waitqueue_head(&thread->wqueue);
> =20
>  	thread->run =3D run;

No, I really don't like that.  It is to focussed on fixing the particular
symptom rather that making the code generally cleaner.

Was there a reason you didn't just change the last arg of md_register_thread
to be the level name instead of NULL??

NeilBrown


--Sig_/W.yWAdzGZ05/GF1u3KQybIN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT82dwznsnt1WYoG5AQIi1w/7ByHKnjaPP/hiUsW+AZrGkbulFkmnET95
5bbSh9mlXK5Su2vAKArNgSq0gtkV5/7AYhBv85oJCNY0TIJYNBOX/iEwO3pcrZ1d
tArmKFdOsu6OST38vvw1L8b5ur6J/i4mT9XYqaBjmQLbraTI7GDtQ6slH9rXbyuu
L1LL1dPsYHgKUVkaAfur41fW+GLGXeua8/3LF3bLNy8uvweoSaO9tOEtdxJonAy4
IC0SrhxwxJ6vXVBQO3LNyJkuuBZe+1j4p7/zvO9ijM8PnRUHQFgNhc8DlaopVD3v
END1YCgh+VkJ6TQ9+EtUq6fghHR46GLOQSsLhhsKMfUfDD3E+ap1Kfhr+HL4CMxe
VXbWIZdc7ZSuDFU8J2HqISqL6UF4I11+5ZyGSQKViBugLm6rRiAFOcbdcoFBw7XR
I22FNimw/kkHQJ0NptZb8EYwlV+PUhZN4POj0yN+HL9WvElhtDwkJBQ/IATt/20s
eMzZ1t/xxLC4N2pJj9XYE33Tj4j9rhOtRid+h2wEEtaju8N7rTW7wWLJIuwRgpWI
rbO8l057XzoLPeEmyZxOWN4KQNM+pT0FXxCNEzj0lkQcQF63yZn93QvVbb0vnd5n
UPxtu66dopKi30UeBb7uK2KTrzYl4jKNY3HqCP8sUrmRMZPS6xEv8g29zMIWUp0x
gZXD4rgPfHk=
=LKim
-----END PGP SIGNATURE-----

--Sig_/W.yWAdzGZ05/GF1u3KQybIN--
