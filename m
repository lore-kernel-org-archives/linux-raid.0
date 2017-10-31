From: NeilBrown <neilb@suse.com>
Subject: Re: Pointer compare in md driver
Date: Tue, 31 Oct 2017 12:03:56 +1100
Message-ID: <87efpkw2kj.fsf@notabene.neil.brown.name>
References: <0D106300-EF8D-45D0-9F7B-392FD9D8E824@mails.ucas.ac.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0D106300-EF8D-45D0-9F7B-392FD9D8E824@mails.ucas.ac.cn>
Sender: linux-raid-owner@vger.kernel.org
To: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Oct 31 2017, wuzhouhui wrote:

> Hi,
>
> Sorry for disturbing, but I have consider this problem for several days.
> I have a question when reading md driver. Following is the code from
> linux/drivers/md/md.c, function md_do_sync():
>
>>                for_each_mddev(mddev2, tmp) {
>>                        if (mddev2 == mddev)
>>                                continue;
>>                        if (!mddev->parallel_resync
>>                        &&  mddev2->curr_resync
>>                        &&  match_mddev_units(mddev, mddev2)) {
>>                                DEFINE_WAIT(wq);
>>                                if (mddev < mddev2 && mddev->curr_resync == 2) {
>>                                        /* arbitrarily yield */
>>                                        mddev->curr_resync = 1;
>>                                        wake_up(&resync_wait);
>>                                }
>>                                if (mddev > mddev2 && mddev->curr_resync == 1)
>>                                        /* no need to wait here, we can wait the next
>>                                         * time 'round when curr_resync == 2
>>                                         */
>>                                        continue;
>>                                /* We need to wait 'interruptible' so as not to
>
> The type of mddev2 and mddev both are struct mddev *, so what's the
> meaning of comparing these two variables?

The ordering of the pointers provides an arbitrary ordering on different
md arrays.
If two arrays need to resync, and they share some devices (e.g. one uses
sda1, sdb1, sdc, and the other uses sda2, sdb2, sdc2, so both arrays use
the devices sda, sdb, and sdc), then the default policy is that only one
gets to resync at a time, the other one has to wait.
If one tries to start resyncing, and the other isn't resyncing, then it
can just go ahead and resync.  If one tries to start resyncing and the
other is already resyncing, then the new one needs to wait.
But what happens if both try to start at much the same time?
If an array is trying to start resync, and it notices that another array
that it shares devices with is also trying to start resync, then the one
with the larger value of the mddev pointer gets to go first.  The one
with the smaller value waits.

Hope that helps,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAln3y/4ACgkQOeye3VZi
gblgxw//blae5NXjh+HHtcNpTnoDwlnvJp4gbrzRiQhWSDDt8nn5xF/zaod0bWmr
2Cym3FhZIgJxCyf7mUmC299H5vpoOJY8n7GcFSTwKpkqTLnYs7dEQf9334wpVWqr
7pNvlUjHcG6beGhUdWiTG5+6t4rvafPoX8JYqt5GbFaJzjf8T0QoDg051YpWMgW2
UZ/P3XAM/Be3CdQ6g8KxtbREmHAtxizux6xEYVISQufODuUqhd48IUsIc7AOAlz7
WP3D3T0Gx3vwMn0BFheY59TYh3oc6+/Kn+u/lItQTSK+LkUq4ETVrtdaCom3TBCQ
Ou4V1IMsd5ixcN2Ag+jxZZlehi5YS3ji34uZc8hCIewg3o+W2efGgKCnNPnNwihF
n9FiC70zDvAJa6Bx8xThYU2n8clNSbTH760Nkt6BrX/y2GCA8BDgauJDRYXElsXt
rP6klCrdWTiadIgAVE6dDZHmHM8GgyaVql9TREe8BUQJCC7GvALpeUeE0m4COksR
xBsPYjiG9Y9ndMLKLuGhrFZj2XlQGORloH5wiPuUAkTwvtw6dQON5KBVCY2lyVhI
kI9bUHfvdsI6j41lpVQF6pbBgGlIgSualO55q3oRr7GOfkJCivp0eZWjXXYCT+wR
7Tlc1+9wn/HWtpYe6Da6+SKzKkQocUHVYx230F8AmaDGj/6YrBk=
=W29u
-----END PGP SIGNATURE-----
--=-=-=--
