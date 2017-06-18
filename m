From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Mon, 19 Jun 2017 07:30:50 +1000
Message-ID: <87vant3rw5.fsf@notabene.neil.brown.name>
References: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com> <877f0c7gvr.fsf@notabene.neil.brown.name> <20170616155204.myffyxp5tuoctcoo@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170616155204.myffyxp5tuoctcoo@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16 2017, Shaohua Li wrote:

> On Fri, Jun 16, 2017 at 01:26:00PM +1000, Neil Brown wrote:
>> On Fri, Jun 09 2017, Shaohua Li wrote:
>>=20
>> > From: Shaohua Li <shli@fb.com>
>> >
>> > suspend range is controlled by userspace. If userspace doesn't clear s=
uspend
>> > range, it's possible a thread will wait for the range forever, we can'=
t even
>> > kill it. This is bad behavior. Add a timeout in the wait. If timeout h=
appens,
>> > we return IO error. The app controlling suspend range looks like part =
of disk
>> > firmware, if disk isn't responded for a long time, timed out IO error =
is
>> > returned.
>> >
>> > A simple search in SCSI code shows maximum IO timeout is 120s, so I us=
e this
>> > value here too.
>>=20
>> I really don't like this.  It is an API change with no really
>> justification.  Has the current behavior caused a problem?
>
> This centainly causes problem. Set the suspend range will make application
> stall for ever, don't you think this is a problem?

I agree that it could cause a problem.  I'm asking it is actually, in
practice, causes a problem.  Do you have reports from people saying "the
IO to my RAID array is hanging, what is wrong?" and you look into it and
find out that suspend_hi is larger than suspend_lo?

And if that does happen, is this really the best way to fix it?

>
>> Both md and dm export  APIs which allow IO to be suspended while
>> changes are made.  Changing that to a timed-out period needs, I think,
>> to be clearly justified.
>>=20
>> If it is changed to a timed-out period, then that should be explicit,
>> rather than having each request independently time out.
>> i.e. when the suspend is initiated, the end-time should be computed, and
>> any IO would block until that time, not block for some number of
>> seconds.
>
> Ok, this makes sense. We can add a timeout. If it's expired, we clear sus=
pend
> range. Userspace should know what they are doing.
>
>>=20
>> If an md device is left suspended, then the current code will block IO
>> indefinitely.  This patch will at a 20minute times to every single
>> request, which will mean IO proceeds, but extremely slowly.  I don't see
>> that as a useful improvement.
>
> It returns error, so application will not dispatch more IO. But I agree a
> timeout to clear the suspend looks a better policy.

Write errors only get back to the application if it calls fsync(), and
many don't do that.  Write errors can easily cause a filesystem to go
read-only, and require an fsck.  I think we should be very cautious
about triggering write errors.

NFS will hang indefinitely rather then return an error if the server is
not available.  That can certainly be annoying, but the alternative has
been tried, and it leads to random data corruption.
The two cases are only comparable at a very high level, but I think
this result should encourage substantial caution.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllG8Q0ACgkQOeye3VZi
gbmSYRAAxGmYXwA0boqjcyMifWuTrFHqSYH3sR97Wof9eCROd0CmJWOwphiLeUvp
cPFENc/rxt1vPbzOR/6FaGbQPbltRZqKRZxPTCR7q2XRclLOdMDtxdl5LxSgttpb
t0A89GQTt+8g/38JGHa7AT/6pkEcFAVUBtkHk50cC5xfEYLXbd8cXlGiogLTH18J
Wyg7dGRejh1edqTESBLfixOa+MXFa/BfZkqxvA90+PIuB5/LbdFbbrNzeAnyDWVC
Ufzs67TeoRLMWakrzobVlPlNAe3or5rMJRcePC7Cu3L74bx1IXd04C6kqktotZmc
3rQ72Xej1Z+9E+Rh1LSEy5tKjwPx6LLFqjMFkprlP6n6hMpXPzp30A/RDtOJJGEE
9N0wL605N4W636fFyqj7dNUBzMzLTIf8Qy7KmnRBLGNiYTjcmmJk2bEJclQ2yq5E
UrDfWrh4Znq8M+gcXU11z1ENZKVXL8qcbzyhBXdkGYgp6hlP0HOqR5oqpEci8p8v
GQThSkIdFp88z/YzznORuYjljYJuEbYzIaP0Ob1kBykpEoYYr1PuCplRszYeq95Z
RuJZcAvxHL9mzB7kiwaT4khxV1M4WAKFXorOdCKq2B73QbCwNM51fNmbmcXnIcPB
Rute/NhfC57d5NRbM8qI5V0SMC6iUZDHMol/L0k07ErytuZ0Exg=
=MUy4
-----END PGP SIGNATURE-----
--=-=-=--
