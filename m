From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: question about the best suited RAID level/layout
Date: Fri, 05 Jul 2013 00:58:07 +0200
Message-ID: <1372978687.5249.52.camel@fermat.scientia.net>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>
	 <51D5EC8A.40509@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="sha1"; protocol="application/x-pkcs7-signature"; boundary="=-pv7lyeqmUc6lAk+Ysubh"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D5EC8A.40509@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-pv7lyeqmUc6lAk+Ysubh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Phil.


On Thu, 2013-07-04 at 17:43 -0400, Phil Turmel wrote:
> > The focus is absolutely on data security/resilience,... and not at all
> > on performance.
> This particular statement trumps all other considerations.
Sarcasm? (*Sheldon Cooper hat on*)


> Triple-copy raid10
> across four drives can match that resiliency, with dramatically better
> performance, but with a substantial cost in capacity.
hmm I've briefly thought about that as well (just forgot to mention
it)... for some reason (probably a non-reason) I've always had a bad
feeling with respect to that uneven mixing (i.e. three copies on four
disks), AFAIU that would look like (each same number being the same
chunck:
+---------+ +---------+ +---------+ +---------+
|   sda   | |   sdb   | |   sdc   | |   sdd   |
+---------+ +---------+ +---------+ +---------+
  0  1  2     0  1  3     0  2  3     1  2  3
  4  5  6     4  5  7     4  6  7     5  6  7
  8  9  10    8  9  11    8  10 11    9  10 11

And that gives me again, any 2 disks... but so much better performance?

With 4x 4TiB disks,.. RAID6 would give me 16/2 TiB... and the above
would give me 16/3 TiB?!
Quite a loss...

And AFAIU it doesn't give me any better resilience than RAID6 (by tricks
like probabilities or so)?

Can it be grown? Like when I want to use the 5th bay? What would it be
then, still any 2 out of 5?


> Two-failure resilience is vital to completing recovery after replacing a
> failed drive, particularly when the read error rates of consumer-grade
> drives are involved.
Well,... I have enterprise disks, and I have backups on different
media,... but nevertheless,... I wouldn't "risk" RAID5 for my precious
data

> In your specific case, raid6 has one additional advantage: making future
> expansion to the fifth bay a reliable, simple, no downtime event.
Ah... so I couldn't online/offline grow a RAID10 with n/f/o=3D3 ?


> In your situation, I would use raid6.  To mitigate the performance hit
> on occasional random-access work, I would use a small chunk size (I use
> 16k).  That will somewhat hurt peak linear performance, but even
> bluray-equivalent media streams only amount to 5 MB/s or so.  That would
> be 80 IOPS per device in such a four-drive raid6.
I think RAID6 will be what I go for, at least unless the RAID10 with
three blocks gives me any resilience bonus, which I can't see right now.


Any ideas about the layout? i.e. left-symmetric-6, right-symmetric-6,
left-asymmetric-6, right-asymmetric-6, and parity-first-6 ?



I'd have even one more question here: Has anyone experience with my idea
of intentionally running devices of different vendors (Seagate, WD,
HGST)... for resilience reasons?... Does it work out as I plan, or are
there any hidden caveats I can't see which make the resilience (not the
performance) worse?



Thanks :),
Chris.

--=-pv7lyeqmUc6lAk+Ysubh
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


--=-pv7lyeqmUc6lAk+Ysubh--

