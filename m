From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] md: separate flags for superblock changes
Date: Fri, 09 Dec 2016 15:43:58 +1100
Message-ID: <87lgvp1zld.fsf@notabene.neil.brown.name>
References: <cover.1481240632.git.shli@fb.com> <a836dcdaef1cecec422f492cca1c4e525034d0e6.1481240632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a836dcdaef1cecec422f492cca1c4e525034d0e6.1481240632.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Dec 09 2016, Shaohua Li wrote:

> The mddev->flags are used for different purposes. There are a lot of
> places we check/change the flags without masking unrelated flags, we
> could check/change unrelated flags. These usage are most for superblock
> write, so spearate superblock related flags. This should make the code
> clearer and also fix real bugs.
>
> Signed-off-by: Shaohua Li <shli@fb.com>

That real bug would be:

>  		md_wakeup_thread(mddev->thread);
> -		wait_event(mddev->sb_wait, mddev->flags == 0 ||
> +		wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
>  			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));

??

mddev->flags used to be called mddev->sb_dirty, before
Commit: 850b2b420cd5 ("[PATCH] md: replace magic numbers in sb_dirty with well defined bit flags")

Then we added lots of other flags.  Now we are going back to the same
idea :-)

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhKNo4ACgkQOeye3VZi
gbnPKA/6Ao54QhyQbdkqgdGzRGgMJay3t6LU0620xG3me5kPdqKqoS0WSD2oksfr
54Cnk4c89N94bcVTNwYMWS7WarnwVdXGjpqyTYhZDV2Crl45Z80/BeZrbWzlXAKA
jOnaUGMKlQ6hfifh8UrxEQPPDWRxl3c/QPDrGN5TDjJoIsSBbBjhN9Jrk90oH1b+
NQ4f4D05HcMRWHDTJs97qLZKniEVUsw/ylV6YDxZ+wrNnKHE8+wcuuyuu1gChxYv
GgjjWTUDwIDlcj/3B3FHFdZUB3GTHk+Ol3Qcjlki5pJ8aVLtnF4LfB64qiVn6hLk
17jwaGESa0fmSEhijd/M/pqInQBpgOkUfwYbPwswli2XU/F2JR17XchrzerB6/TB
U1d3zbnfhjSmpRFvk/wQVz/g6P8jFILtzFhOvRFWqbm4384oSCKzBueZJXeVlauk
3t6u8vK7mKeU4GTAac7H9lM8pFahhrgK+t7bYPVooLXEwYGqy1SkdW+NzM2L+KU8
P8n41elJg5DfdLTq3cAqK7f9w2PzUXt4fx6L7GTLYlHGAtLgrhCM6z9tolzdsV1E
q911IJSqeauPVcC9F5Qxr0hhKpJpIDVx5HKbLpk5hxid6o6Mvs8dnTKvVlstoAeu
vApKVYN4EIoQPXpZ43e3pTh4ujJuSESFDRcbM9L64pzx2mcaWnc=
=aIzM
-----END PGP SIGNATURE-----
--=-=-=--
