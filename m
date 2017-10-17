From: NeilBrown <neilb@suse.com>
Subject: Re: Wiki, raid 10, and my new system :-)
Date: Tue, 17 Oct 2017 11:42:17 +1100
Message-ID: <87vajek3km.fsf@notabene.neil.brown.name>
References: <59E4BA29.4050907@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59E4BA29.4050907@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Oct 16 2017, Wols Lists wrote:

> Raid 10 is a complicated subject what with near and far, and whether it
> will grow, etc etc.
>
> I'm planning to raid-10 my swap partition, and while it doesn't matter
> in the slightest because destroying and recreating will be no hassle for
> swap, I'd like to understand what's going on.
>
> If I remember correctly, there was a thread a little while back on
> growing a raid-10? And you can't (for certain values of "can't" :-) do it?

You can for sufficiently recent kernels, and for layouts that support
reshape :-)

>
> Where's the best place to find info about near, far and offset layouts?
> I seem to remember "man md", but is there anywhere better?

Use the source, Luke.

	 * Currently we reject any reshape of a 'far' mode array,
	 * allow chunk size to change if new is generally acceptable,
	 * allow raid_disks to increase, and allow
	 * a switch between 'near' mode and 'offset' mode.

though the code seems to allow raid_disks to decrease as well.

I recommend testing different changes on different configurations and
seeing which ones work.

>
> To give you an idea of what I'm planning, I've currently got 2 x 4TB
> drives that will have a swap partition. I know if I raid-10 that it's
> effectively just a raid-1 mirror, but I intend to add a third, and then
> probably a fourth, drive. Can you do that? What will the result be? And
> for swap especially, does anybody know if I should optimise for read or
> write - common sense says they're equally important but as a scientist I
> know common sense is not to be trusted :-)

As long as you don't choose the 'far' layout, you will be able to
increase the number of devices in the raid10.
If the performance of swap ever becomes an issue, you have lost
already (I'm more of the philosopher than the scientist today).

>
> Of course, all this will end up on the wiki :-)

Thanks!

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnlUesACgkQOeye3VZi
gbnozw/9E8xQTSBpicyw8RVqg6pfYYnRRgAx+eY72wdAWHGErEOsX2tAJLti+eSn
YeSSP6M5EKSPX6hNM1KppMElTQP2bqmmi9+KUuxW0Sq++baMvvCyY8fJdESRH+Ym
BJsUDSFmmR1hSexYIKrWF6ctITXxNI4l1Mw4s2slnef3izE47iBaO2WXKICyBTox
1pwybS7vmWsDGDiNRioFeUc8ndH2D9XFn1JBVn9nF9HFe0dWmH4H+cMVmoa4m+Gk
3MpukfzQRwigtEeFZtg+P+xjixOYSbGecrcdWrBPm2y+kTDrEdhZtLCgYGq9ff+M
E8Z0AghMfaUIBEgWliEhaKD8EYm9F8ZOGzvjAlLcAKO+bCo22w+Tg9JO1z9UyPdz
UzK3MTmGKjmiNJSfCEKnFcEAUQrZjpacD7Q7NhSEILs/IgX4kR+uoee0mjLKr+V7
1jTbqFTjwSw/RBlh9x2+4rf9YCwJVOfct1WAL4IMKPaRhWeXA+fkaoQZa+DLB/eR
f9b0V3g4wPmRL6ubzJcVKaOaz/hyzyyuPB8gY0RCBJIPobxAlvXJfV4+40p/cyO7
+4+WqRHV+IayHAX7bwTo5XKC/eDi1z00XpP5619ujOJAyFFblTRH12gFmku+InPj
Rvp/ltjHnWwg3uutJu/xgBG0iBZwy6+XfAcCuSx43ek/G29R/a0=
=lQfF
-----END PGP SIGNATURE-----
--=-=-=--
