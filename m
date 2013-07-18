From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: shown disk sizes
Date: Thu, 18 Jul 2013 02:39:39 +0200
Message-ID: <1374107979.5260.21.camel@fermat.scientia.net>
References: <1374071867.25339.14.camel@heisenberg.scientia.net>
	 <20130718094327.7d46949e@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="sha1"; protocol="application/x-pkcs7-signature"; boundary="=-JDNk5qnmSi6Nn+VeRoKy"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130718094327.7d46949e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-JDNk5qnmSi6Nn+VeRoKy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-18 at 09:43 +1000, NeilBrown wrote:
> Yes - this mailing list.
> The protocol is that as long as you care about the issue and haven't had
> satisfactory response, you post a "Can anyone help with this" every week =
or
> so.
> That way we don't have a problem with lots of stale entries that no-one c=
ares
> about.
okay... guess I need to track my ideas for additions to the
documentation (like the ones below) somewhere else than... =3D)


> chunksize is not very meaningful for RAID1.  If you add '-v' mdadm should
> tell you:
>   mdadm: chunk size ignored for this level
Yeah... sure... I just made some tests and re-used the history from a
previous raid6 and didn't remove the useless stuff ;)


> Maybe it should round the size down to a multiple of the given chunk size=
,
> but as you said "--size=3Dmax", maybe not..  Not sure.
Interesting question... I'll try that later... maybe something we can
add to the manpage as well.


> > =3D> Why is the array size / used dev size smaller?
>=20
> Good question.  Not easy to answer ... it is rather convoluted.  Differen=
t
> bits of code try to reserve space for things differently and they don't e=
nd
> up agreeing.  I might try to simplify that.
Okay... I have no idea what you're talking about ;-)
It seems to it's always 144 sectors that are "missing"...

What do you mean by simplify?


> > --detail gives:
> >      Array Size : 10484664 (10.00 GiB 10.74 GB)
> >   Used Dev Size : 10484664 (10.00 GiB 10.74 GB)
> >=20
> > =3D> That's half of the Array Size from above? Is that a bug?
> The number is in K rather than sectors.  Sorry :-(
You know that these are the reasons why kernel developers may end up in
hell?! ;-P

okay... I guess again something for the documentation... or would you
see a problem to change the output to at least include the unit?
Like=20
Array Size (KiB) or so?


> Would that really help?  Given that 10.00GiB is not exactly the same as
> 10.74GB, isn't it obvious that they must be approximations?
>=20
> I'm not exactly against adding '~' but it doesn't seem necessary.
> Does anyone else have thoughts?
I don't think it's strictly necessary as well... but I guess it would be
cleaner...


Cheers,
Chris.

--=-JDNk5qnmSi6Nn+VeRoKy
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQ/jCCBXUw
ggNdoAMCAQICAwEBgjANBgkqhkiG9w0BAQUFADBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwG
A1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290
MB4XDTEyMDcyMzE0NTY0NVoXDTE0MDcyMzE0NTY0NVowfDEhMB8GA1UEAxMYQ2hyaXN0b3BoIEFu
dG9uIE1pdHRlcmVyMSQwIgYJKoZIhvcNAQkBFhVjYWxlc3R5b0BzY2llbnRpYS5uZXQxMTAvBgkq
hkiG9w0BCQEWIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQCq/4X3Urm/IHCIYUyqPrBN6FZ2pmd8V5epPyDlveqtdYvLBLNy
gP3G3KhGoCA4Jf49KYGmbqk+F7fVWcG1zcdwEx7itKJyj39nYf2HWXogxUSfKFptbOgpsTcEWuxg
ka2EkJuErTvYbwCEKT7mn4v6ScuFBc3Q+Hswlt1jbqjczi+OxcU1skvxM5jGjzRwYPUsiHZJRkWp
ogbbhNWZNbwXiMPln380TAlryRAr5UE0dSe1dg1qHhF6HSNKwaer0+Dcd/goL4XQhHxCAGZKfCK0
wVRf1SeEsS9FDGMMjW2b6HpHF+OVXuagjrxSWHttx0+Ez/PZDXpeZpjXatzzmlJFAgMBAAGjggEm
MIIBIjAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlm
aWNhdGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzBABgNVHSUE
OTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCGSAGG+EIE
ATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2VydC5vcmcwRAYD
VR0RBD0wO4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0gSJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0
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


--=-JDNk5qnmSi6Nn+VeRoKy--

