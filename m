From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: md homehost
Date: Thu, 25 Feb 2010 12:55:29 +0100
Message-ID: <20100225115529.GA1608@darkside.12.kls.lan>
References: <20100219091619.GA2964@lazy.lzy>
 <20100221174007.GB19058@lapse.rw.madduck.net>
 <20100221201304.GB2570@lazy.lzy>
 <20100222091632.GE2641@lapse.rw.madduck.net>
 <20100223133028.279e0174@notabene.brown>
 <20100223062700.GB19666@lapse.rw.madduck.net>
 <20100224111006.7024c84e@notabene.brown>
 <87d3zulpj7.fsf@frosties.localdomain>
 <20100225093018.12d3e14d@notabene.brown>
 <87eik94wg1.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87eik94wg1.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Neil Brown <neilb@suse.de>, martin f krafft <madduck@madduck.net>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, 567468@bugs.debian.org, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 25, 2010 at 08:16:14AM +0100, Goswin von Brederlow wrote:
> Yes you can do something about it: Only start the raid arrays with the
> correct homehost.

I agree with you that auto-assembling devices with non-matching homehost
(and unknown UUID) is probably not the best idea.

> If the homehost is only used to decide wether the prefered minor in the
> metadata is used for the device name then I feel the feature is entirely
> useless. It would only help in "stupid" configurations, i.e. when you
> use the device name directly.

I don't think this is a "stupid" configuration. md was one of the first
subsystems providing stable device names and I think they are widely
used - alone for historical reasons.
I personally feel way better relying on md device names than on some
UUIDs. The former are just far more stable than some UUID of some
filesystem which changes every time you re-create it. UUIDs of md
devices do change as well if you re-create them, but their name remains.

Yes, I'm aware of filesystem labels, but they rise the same problems as
md devices without homehost attribute.


Mario
--=20
There are trivial truths and the great truths.
The opposite of a trivial truth is plainly false.
The opposite of a great truth is also true.
                                    -- Niels Bohr

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBS4ZlMRS+e2HeSPbpAQKdpAgAhonicgmFEQip/jNpuuhnaHzc7q+RqcA4
KHB2jAqxxFuxj9PagQCfnHYSceEL9zvbp8Xk1p3T/C6gt5OGxuvnTcKeg5vrvH1W
uBO0CD4eOuZtiOGqKx2GSnjCof3Gl6BG1ry1bwyrLsbSwQYfBCMgNQxLj1hX26Iv
hWTH+kjJskaTNhyFGuy9pxle56FglxjEn9GmVnHiCmE/Zk+stpGRDI6I2REixWfu
Xg/be4uEVKg3PRT5CA9JucrB65WPK/AmEQoynJd3z2jPtLaE7gns2M+Q992UGLT2
OCsVlcPXKxo+VS8iK22w3lYf8Ok+h6w4w2GVtuS/jjy8FL+ax9+uZQ==
=htSf
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
