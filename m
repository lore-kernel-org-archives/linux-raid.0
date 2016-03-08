From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/8] bitmap: Fix resource leak in bitmap_file_open()
Date: Wed, 09 Mar 2016 09:50:50 +1100
Message-ID: <87a8m8lh2t.fsf@notabene.neil.brown.name>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com> <1457458252-20203-7-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-7-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
Cc: gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> The code would leak 'fd' if locate_bitmap() failed.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  bitmap.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/bitmap.c b/bitmap.c
> index 5ad7401..0367d13 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -224,6 +224,7 @@ int bitmap_file_open(char *filename, struct supertype **stp, int node_num)
>  		} else {
>  			if (st->ss->locate_bitmap(st, fd, node_num)) {
>  				pr_err("%s doesn't have bitmap\n", filename);
> +				close(fd);
>  				fd = -1;
>  			}
>  		}

Don't you also need a 'close' in

		} else if (!st->ss->locate_bitmap) {
			pr_err("No bitmap possible with %s metadata\n",
				st->ss->name);
			return -1;
??

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW31dKAAoJEDnsnt1WYoG5NhUP/1DvP9WWGoKQsb+aVsnF80dq
DKzePlubqTpRlg+7w/Lm4glzNkLpZWnMYJXw778Nfei4ae/u9wkIydn6ppV/U6zZ
KMfnoXdAHsP86F+RqBE4AEAt3qwGQPos1kz78OmGemNTJkOsx8lGAPBvTQU3MbRo
58SyPhj/37tmo1nyMb7WaydqR3/uCAxTDb/epqvtuEY1Gw+PDBBdnxC1uj4+pfsk
5PNEUVHwalWMVog1GZu4X/v2yYpJ6L13Rf96y1pBU27EdnYCtmYupODIsOmLUlRq
f6cTXF1i3TWk3pB/hKiJemVkRB2DWZjnBPJKJpTapZU+YrSbhsfiC7+eNvPyeXyB
UVTCENArnTUyavs0vCoqSI0nPl0RLtKX2Rgv5zrfQP9j9LTx2nxu8AJVx0M9J5i8
9U9NYgG0YG06RDYPBz7TJzMyQqrIJvtExjphhOlTjD046xRQVvw48sH35z9yhGc5
j4OVmmfY7ttWg3nE803aocubCXCckPreDtcaIB4CMv6t2PaP0RjhwDA4QwZ904w6
9Sv2yonUdUvjKoio94kpi/1MPykeKxLVCzFpFVswW41NTmrowAewuIgokwnWPirB
oNFTgvj1pWWNMR4GXECYRk0ADxysMlshVl+WZGHR65CYbWD+3Y0XrHA+hjsUxC1j
jtUUOBd5q0v3lkfZjwTp
=Tb0X
-----END PGP SIGNATURE-----
--=-=-=--
