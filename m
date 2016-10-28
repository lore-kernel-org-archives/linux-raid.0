From: NeilBrown <neilb@suse.com>
Subject: Re: growing a RAID-10 array with mdadm 3.3.1+ ?
Date: Fri, 28 Oct 2016 16:47:11 +1100
Message-ID: <87wpgtrpnk.fsf@notabene.neil.brown.name>
References: <1476206815.989242.752665505.6525EE00@webmail.messagingengine.com> <a09a7ce1-8adf-e00c-7787-eb7ccc1a9e63@youngman.org.uk> <1476211037.1004490.752738017.68CF1E3E@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1476211037.1004490.752738017.68CF1E3E@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: moft@fmailbox.com, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12 2016, moft@fmailbox.com wrote:

> On Tue, Oct 11, 2016, at 11:29 AM, Anthony Youngman wrote:
>> Growing an array is pretty safe, but like anything here, it does have  i=
ts dangers.
>>=20
>> Second, what distro are you running? Is it a systemd-based distro?
>
> Opensuse. Yes.

Specifically, which openSUSE.  What version of mdadm. >=20

>
>> feeling is that systemd is "to blame".=20
>
> I have no idea why that'd be the case.  That's the first time I've heard =
anybody suggest that.

Debian bug 840743 helped me see a possible reason.

In some cases mdadm need to remain running in the background to monitor
the reshape.  Systemd doesn't like us to do that (it likes to kill
background tasks when you log off).
So on systemd installs we use a systemd service to run
  mdadm --grow --continue
There was a bug in mdadm 3.3.x, fixed in 3.4, which caused that mdadm to
fail (at least in some circumstances).
The the reshape froze at the start.


>
>> > *CAN* I safely grow/expand it?
>>=20
>> Bugs excepted - yes you should be able to, without problems.
>
> So grouwing 'far' layouts are now supported?  Do have a
> reference/source for that?

No, 'far' layout RAID10 cannot be reshaped.  There are some messy issues
with making that work sensibly which I never bothered to resolve.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYEuZfAAoJEDnsnt1WYoG5UpgQAIfLZmO6mZAzwrvDFLUQ5cGz
q+cyMETSawAxeyEmfX4suv6oAuAILozBND7kzpmpPRvnzPRd5I4+UV/5Jfm6L21T
7T88i4kW6YjNKtj1EHRnf5YBM1d/Zz6miHxn0gAryswqn7U9orhk4ywNYfBj5fVd
RVG5SMsXR8FRqDIX1S6zZLIGx26d5fC+tZzC33+s5Rc+9krI3rvQka3XL5NNxgeT
xW8mLglQJGoXpvM76OqP3DRYtBC6WECykSkrwkU2lOdXxTYIK6iS3k1WRycG8j0g
FxJ7fTYKqqM1Um08s4M8jmsqaasgVXsF9FLlQZY81tUDyMXY/wqM8MWWBs3IAPbv
0BtpLY0XWraedqe2rULx/SyMtvf4YNhHijQ9ZDWpiSNvEIhcoWpJyRerUtCZaVui
idbeKMUYEEnahn2Uo7A3i5gWSCjTx9CVA0UNYfSKJFeqpH3anpKB2NmG7vqDE7EP
JGlYo55bi9TjJ0H2CJshIOwGDPTopYmzlHymlwzGFknGBPGBTwCsAqJszb4j35cR
wCPanKhJK2msmCrQsFvt0osxu9MIIu7yXH8AhIv5Fe7GsqlGs4FKrcmGPtfpX0ia
wRnJLq8QNWmFAFUu0G0MtaEK+MZ9xkVa9dfTYJJOVPTwYSr2CMXFsTlvzz+/oRCb
57mvG3H7iT3Ch3kkxHCu
=nOwm
-----END PGP SIGNATURE-----
--=-=-=--
