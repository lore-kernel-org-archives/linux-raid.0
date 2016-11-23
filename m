From: NeilBrown <neilb@suse.com>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Wed, 23 Nov 2016 13:34:52 +1100
Message-ID: <87wpfuc4ab.fsf@notabene.neil.brown.name>
References: <20161117150954.GH21587@bitfolk.com> <87d1hthgm7.fsf@notabene.neil.brown.name> <20161118023144.GC1804@bitfolk.com> <87poltfq2d.fsf@notabene.neil.brown.name> <20161118034716.GI21587@bitfolk.com> <87k2c1fn0o.fsf@notabene.neil.brown.name> <20161118041759.GE1804@bitfolk.com> <877f7xe9lh.fsf@notabene.neil.brown.name> <20161121060256.GL1804@bitfolk.com> <87shqkcuhv.fsf@notabene.neil.brown.name> <20161122060105.GS1804@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161122060105.GS1804@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org, 784070@bugs.debian.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22 2016, Andy Smith wrote:

> Hi Neil,
>
> On Tue, Nov 22, 2016 at 09:56:28AM +1100, NeilBrown wrote:
>> Thanks.  Sorry this is taking a lot of back-and-forth...
>
> No worries. This is very interesting to me and I'd also like to know
> what is going wrong even if I have a work-around.

Thanks.
I tried this on a scratch Debian VM I had lying around, and found I
could exactly reproduce your symptoms.
I found that, unlike on the first Debian system I looked at, there is a
line in  /lib/udev/rules.d/64-md-raid-assembly.rules=20

  # Disable incremental assembly to fix Debian bug #784070
  GOTO=3D"md_inc_end"

Remove that and the problem goes away.  Arrgg...

I wish people maintainers would *ask* upstream when they don't
understand, rather than just breaking things.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNQBMAAoJEDnsnt1WYoG53VYQAKBgJAnFqV7Oz06mg6UhIjUE
+q416Ng/ZBfNY0QycNU6nqX16vs1ZtDKWo+f2H1RLQcTlghMrwoZEBjTn4QRXIvI
ixzphChWEi+FNXde0pwrRv2yQ+GUO3BVSNpOYw7rNjCD18fF8S619ttmmCZDapky
QcvdsqYI6UmL7As1Q9FOHnF1zyptRgd4oU9Qhi8BAITbWyyIj0owFc+7Hz7bE0g4
uSk0JNy+x6OSwCDCHaUqkFphATrgr+iTZwvJLWwrIRKqLkhdOd0/AdGAYrKKMfJ5
PpHl98UvyybJ3wf/S3hd5cYIjlcCwgvR/9qPWe3Pkc4ZytfikFspGoFkr3MS0AMM
n8nraqiMTZaRiL7GRrNWUnGIudNOMvedkhja5D18T9YrMr396jGCNF652QLw0/uV
tV8szeYXJWXQk43SB6k7b3ZJvGuoJT6QWX3YF8u7uhKbsDe9mvDiJ3sMpptS0OjV
aRt/Bng3zBAHe90g63qlba6M+GCioyhEGU6nFdMtp0LPPRNohyYLrhOUCS4E6+96
Mx32RJ57PsUsw97n4YO3QJoIrJbRFaCkCuw/9Dyl05rxOT8SL5T7VW7UwrMzjoe6
nNVG5bHrQRbdbbTXZBB2kde7FCGcNHhhF0xcj+scQtCN8ENnGpUb0nogoEaKdnNt
j5R0s79FjtmUN9JgJhs4
=N9Jp
-----END PGP SIGNATURE-----
--=-=-=--
