From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH RFC] test: revise 'test' and make it easier to understand
Date: Fri, 03 Mar 2017 09:26:43 +1100
Message-ID: <87mvd3nwm4.fsf@notabene.neil.brown.name>
References: <a81137d5-3042-e983-fe0e-1b9a0de836ff@suse.com> <1488250053-10436-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488250053-10436-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Feb 28 2017, Zhilong Liu wrote:

> 1. use 'Tab' as the code style.
> 2. arrange the testing steps and provide the 'main' entrance.
> 3. draft the log_save feature, it captures the /proc/mdstat,
>    md superblock info, bitmap info and the detail dmesg.
> 4. modified the mdadm() func, adding the operation that clear
>    the superblock when create or build one new array, and it
>    would exit testing when mdadm command returned non-0 value.
> 5. delete no_errors() func, it only used in tests/04update-uuid,
>    I recommend the new mdadm() using method.
> 6. delete fast_sync() func.
> 7. testdev(), add the object file checking, otherwise this command
>    would create one regular file, it's one trouble thing.
> 8. add dmesg checking in do_test() func, it's necessary to check
>    dmesg whether or not printed abnormal message.
> 9. add checking conditions in main(), such as $pwd/raid6check need
>    exists, here is a prompt to remind users to 'make everything'
>    before testing; the $targetdir should mount under ext[2-4] FS,
>    because the external bitmap only supports ext, the bmap() API
>    of bitmap.c doesn't exist in all filesystem, such as btrfs.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

I haven't looked at this patch in any great detail, but I just wanted to
say I think it is great that 'test' is getting some attention like this.
I sort of just grew over the years without any clear plan.  It probably
has all sorts of strange things in it that don't make a lot of sense any
more.
So I've very happy for you to rip it apart and put it together is a more
coherent form.  Thanks!

Acked-by: NeilBrown <neilb@suse.com>

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli4nCMACgkQOeye3VZi
gbmNOhAAka27iBfbqx4alHOwXB4t+f/EdmccEVXprnFPFNxF3AbDC7pYRWNiNNez
SOUUcHq0R+SdFt9CkO+kxTDIHZ4KRrUImGNqAmSZdoB6LkMyiHslIeh5s6YVyKoO
VSXY5G+X5HD5tH+APHoRiXRog/bGcBUMSz1/ooXhNiqDxh7IYlwrd6A5KFS9uVel
n5MwmkqqQLxCnExVrfE3LZJu7PSz2Sb1MJFhKTCleKTy91fzRciLLmkfbEVlNyDw
2yc3LTe7aWZm7lFQ6u+NvmO5HD/OasFCWPetE/+BwEzFK6TfpDLQNZPVa+vNk3DM
hTLnTBFk6LUOy3V3b++wrApmh3SYmUg29gV8cCRromFvZkhZ8/7ktqEY89Iy13xe
WsjqfCd3pDeM8WGiihGJqMmbnptm+WC5rDlkdyNtx9cc+QT6OZPDZ4L6XjTaXV3O
GD4Iewde6SDBgmC50oDbeSGxkR/dvGw+TNmnsqfaJBWW3qfFyXTssPbrQIpetYAP
KAMn+NH7pL8mMOqhYCGJQdRC7tgG4RvVXlFfag2Xa3gXRTCW9vF8c2Vo5r/8Sqih
0vKJmzmvgHsDukcwY2II9132OEeX+KqPh70XeW3u20uwrFTXbxSuzEpn8TmC7RAC
h2PnKSfhl26w2CWLl8HDD+ldqLh9GO6r0N5rYxD6MJIM8XjpX9w=
=2DM9
-----END PGP SIGNATURE-----
--=-=-=--
