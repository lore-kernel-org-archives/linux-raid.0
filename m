From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm-2.6.7.1 0/3] Misc fixes for mdadm-2.6.7.1
Date: Thu, 30 Oct 2008 13:40:29 -0400
Message-ID: <1225388429.26510.159.camel@firewall.xsintricity.com>
References: <cover.1225306892.git.dledford@redhat.com>
	 <18696.59934.872875.299706@notabene.brown>
	 <1225322045.26510.86.camel@firewall.xsintricity.com>
	 <18697.4580.911971.968652@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LaBB+LBJ3N0xIQS95fKf"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18697.4580.911971.968652@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-LaBB+LBJ3N0xIQS95fKf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 12:46 +1100, Neil Brown wrote:
> So if the name "/dev/md0" is given in mdadm.conf, we can only create a
> non-partitioned array.  But what do we do if 'autof' suggests that a
> partitioned array should be created (auto=3Dmdp4)?

With my patch that would have thrown a config error.

> I think that if the "auto=3Dmdp4" was on the ARRAY line, then we want to
> reject that as a config error.  But if the auto=3Dmdp4 was on the
> command line or the CREATE line, then the device name over-rides.
> Does that seem reasonable?

Sure.

> That makes me wonder if we have the precedence order of auto=3D right.
> Maybe the ARRAY line should override as it is specific to the array.
> Then the command line is next important.  Then the CREATE is the last
> default.   I think that is different to the order that you had.
> Is there some particular reason that you though the command line
> should override in the --incremental case?

Truly, I had forgotten my changes were going to be --incremental
specific and instead was thinking to myself "Gee, if someone wants to
assemble an array differently than normal, then let them go ahead by
specifying what they want on the command line" when that line of thought
would obviously apply to assemble mode, not incremental mode.  Maybe
it's because I was running incremental manually to test all this that
this thinko slipped by ;-)

> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-LaBB+LBJ3N0xIQS95fKf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkJ8Y0ACgkQTzP9PM7pjw+clgCcCg+XTa9a8alxLGxSXSdFORNY
3gYAn1LxiVrtekbRb/Yu4A37OQrfQnEM
=WH1v
-----END PGP SIGNATURE-----

--=-LaBB+LBJ3N0xIQS95fKf--

