From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: some general questions on RAID
Date: Fri, 05 Jul 2013 01:34:42 +0200
Message-ID: <1372980882.5249.88.camel@fermat.scientia.net>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>
	 <51D5F22C.70007@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="sha1"; protocol="application/x-pkcs7-signature"; boundary="=-EKldAWquzzuSx4rZ1swa"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D5F22C.70007@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-EKldAWquzzuSx4rZ1swa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-04 at 18:07 -0400, Phil Turmel wrote:
> Last time I checked, dmcrypt treated barriers as no-ops, so filesystems
> that rely on barriers for integrity can be scrambled.
Whow... uhmm... that would be awful... (since I already use ext4 on top
of dmcrypt..
But wouldn't that be a general problem of dmcrypt, unrelated to any
further stacking of LVM and/or MD?!

> As such, where I
> mix LVM and dmcrypt, I do it selectively on top of each LV.
Don't understand what you exactly mean/do and why it should help against
the barrier thingy?


> I believe dmcrypt is single-threaded, too.
I've had thought that, too,..at least it used to be.
So that would basically mean... if I put dmcrypt on top of MD, then one
single thread would handle the whole encryption for the whole MD and
therefore also on all of my (e.g. 4) devices?

But when I do it the other way round... MD being on top of dmcrypt...
than each physical device would get it's own dmcrypt device... and also
it's own thread, using potentially more CPUs?

Well the QNAP in question would have 2 cores with HT so 4 threads...
anyone here with an idea whether the performance boost would be worth
running dmcrypt below MD (which somehow sounds ugly and wrong).


> If either or both of those issues have been corrected, I wouldn't expect
> the layering order to matter.  I'd be nice if a lurking dmcrypt dev or
> enthusiast would chime in here.
I've mailed Milan Broz a pointer to this thread and hope he finds some
time to have a look at :)

If so, a question in addition,... if it's not already done,... are there
plans to make dmcrypt multi-threaded (so I could just wait for it and
put MD below it)?


> > But when looking at potential disaster recovery... I think not having M=
D
> > directly on top of the HDDs (especially having it above dmcrypt) seems
> > stupid.
> I don't know that layering matters much in that case, but I can think of
> many cases where it could complicate things.
What exactly do you mean?

My idea was that when MD is directly above the physical device... then I
will roughly which kind block should be where and how data blocks should
yield parity blocks... i.e. when I do disc forensics or plain dd access.
When dmcrypt is below, though,... all physical devices will look
completely like garbage.


> > 2) Chunks / Chunk size
> > a) How does MD work in that matter... is it that it _always_ reads
> > and/or writes FULL chunks?
>
> No.  It does not.  It doesn't go below 4k though.
So what does that mean exactly? It always reads/writes at least 4k
blocks?


> > Guess it must at least do so on _write_ for the RAID levels with parity
> > (5/6)... but what about read?
> No, not even for write.
:-O

> If an isolated 4k block is written to a raid6,
> the corresponding 4k blocks from the other data drives in that stripe
> are read, both corresponding parity blocks are computed, and the three
> blocks are written.
okay that's clear... but uhm... why having chuk sizes then? I mean
what's the difference when having a 128k chunk vs. a 256k one... when
the parity/data blocks seem to be split in 4k blocks,... or did I get
that completely wrong?


> > And what about read/write with the non-parity RAID levels (1, 0, 10,
> > linear)... is the chunk size of any real influence here (in terms of
> > reading/writing)?
> Not really.  At least, I've seen nothing on this list that shows any
> influence.
So AFAIU now:
a) Regardless the RAID level and regardless the chunk size,
   - data blocks are read/written in 4KiB blocks
   - when there IS parity information... then that parity information is _A=
LWAYS_ read/computed/written in 4KiB blocks.
b) The chunks basically just control how much consecutive data is on one
device, thereby allowing to speed up / slow down reads/write for small /
large files.
But that should basically only matter on seeking devices, i.e. not on
SSDs... thus the chunk size is irrelevant on SSDs...

Is all that right? Phil, Neil? :D



> > b) What's the currently suggested chunk size when having a undetermined
> > [snip]
> For parity raid, large chunk sizes are crazy, IMHO.  As I pointed out in
> another mail, I use 16k for all of mine.
Sounds contradicting to the 4 KiB parity blocks idea?! So why? Or do you
have by chance a URL to your other mail? :)



> > 3) Any extra benefit from the parity?
> > [snip]
> This capability exists as a separate userspace utility "raid6check" that
> is in the process of acceptance into the mdadm toolkit.
Interesting... just looking at it.

>   It is not built
> into the kernel, and Neil Brown has a long blog post explaining why it
> shouldn't ever be.
I'll search for it...

>   Built-in "check" scrubs will report such mismatches,
> and the built-in "repair" scrub fixes them by recomputing all parity
> from the data blocks.
So that basically means, that parity RAID (i.e. RAID6) *HAS* an
resilience advantage even over the 3 block copy RAID10 version that
we've discussed over there[0], right?



Thanks a lot,
Chris.

[0] http://thread.gmane.org/gmane.linux.raid/43405/focus=3D43407

--=-EKldAWquzzuSx4rZ1swa
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


--=-EKldAWquzzuSx4rZ1swa--

