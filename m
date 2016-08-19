From: NeilBrown <nfbrown@novell.com>
Subject: Re: Rewrite md raid1 member
Date: Sat, 20 Aug 2016 07:26:27 +1000
Message-ID: <87oa4oh2m4.fsf@notabene.neil.brown.name>
References: <20160818030451.GA17225@onthe.net.au> <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com> <20160818040151.GA21256@onthe.net.au> <57B6F2F5.8090800@youngman.org.uk> <20160819124615.GA23247@onthe.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160819124615.GA23247@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>, Wols Lists <antlists@youngman.org.uk>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Aug 19 2016, Chris Dunlop wrote:

>
> In my case, I want it to write everything.
>
> If I do my 'dd' to write everything as previously described, with the window
> of opportunity for stale data to end up on the written disk, one option
> would to run a scrub / repair to check the data is the same - but if I'm
> unlucky with my dd and the data isn't the same for some sector[s], I want to
> ensure the correct data is copied over the stale data and not the other way
> around, e.g. to specify "in the event of a mismatch, use the data from sda
> and overwrite the data on sdb".
>
> Unfortunately I don't know how that can be done.
>
> Does anyone know?

If it is the second device in the array (as listed by mdadm --detail)
then you can stop the array and re-assemble with --update=resync.

If it is the first device I can only suggest that you
fail the device and add it again:

 mdadm /dev/mdXX --fail /dev/sdYY
 mdadm /dev/mdXX --remove /dev/sdYY
 mdadm /dev/mdYY --add /dev/sdYY

If the "good" drive fails during the rewrite it might be a little bit
fiddley getting the array working again, but all the data will certainly
be there on the device you are re-writing, so you won't lose anything.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXt3mEAAoJEDnsnt1WYoG5uE8P/1jDplGh00H+HsFIlPVYhfuS
LnE1aWdQj4HcTTQWN9QEahYkwugMee9XkzNGMk/6cPsPKplgqpZxMBJd2U6Fx75U
USEMwCf3F2zostxYcXTjKGk/8hMNhETYoLcinpKD/RZnUVwtQVleqNs8AxaLaMPH
0a2JAzu7M3jpgN07Nxz58Xw2mkhm2NDmz/ht0JF3GXoV+iJUMbsrbpqr8qEg5hVB
cOI4EwwJ+6w4tWV0mhk9L3AhyT8ZmalBc3jBefo/7iv573h2rN3YbNYBjuT23OAW
eMP0ePngKcLIH4tDt0VlgB0EL0cxWxj7OEOoIHCgTibMENEa1X9zYBShLcaHjuX+
b+FmnOKyE6WOu3NeFys8X3dCWsjx6gSf7BUMibg8Cfv6wscmOPN2VgIpgzVPHITA
CJMAgxYpUcm9mS7ggj6gzHz5h66Eb6qvHgYhexMv8/5y3l+pk9nlU2DVND09qu+L
VFqh/Ib+L//NpWVPMI24ubdwQSPKVC5NUiRkH+PNLBCCrtcNmSXLWOGZ75G2dF/i
M6JFeTVnGx7Dy1YXBZwthdagMcWbfaLLjlRN89RmokHZIVqirHWPwX66vlmKW3vs
DsSnJ30+aaOpn8n+8yh09dc4XNqB/L4tng8HhSRo1T1QfLg3jXCcFbR4EfYPi4wf
IlSVuUu8vV2Nn1P4MBBJ
=7ZfX
-----END PGP SIGNATURE-----
--=-=-=--
