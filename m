From: Doug Ledford <dledford@redhat.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 14:00:01 -0400
Message-ID: <51443e5b-3eef-c35f-8ee7-ad3e85e4e76c@redhat.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-Dqesy2TJX7W-bPakzeDcOoNy0VoSWWM06rKMYMhyhY7g@mail.gmail.com>
 <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
 <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3b7lOEtCA7osNvvhdtmhB9lPlKvEC2vrv"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3b7lOEtCA7osNvvhdtmhB9lPlKvEC2vrv
Content-Type: multipart/mixed; boundary="WfSVMDVmHOgF6NCO7l7SPuPOAGEaoV1uq"
From: Doug Ledford <dledford@redhat.com>
To: Matt Garman <matthew.garman@gmail.com>, Doug Dumitru <doug@easyco.com>,
 Mdadm <linux-raid@vger.kernel.org>
Message-ID: <51443e5b-3eef-c35f-8ee7-ad3e85e4e76c@redhat.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-Dqesy2TJX7W-bPakzeDcOoNy0VoSWWM06rKMYMhyhY7g@mail.gmail.com>
 <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
 <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>
In-Reply-To: <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>

--WfSVMDVmHOgF6NCO7l7SPuPOAGEaoV1uq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 10:54 AM, Matt Garman wrote:
> On Tue, Aug 16, 2016 at 11:36 AM, Doug Dumitru <doug@easyco.com> wrote:=

>> The RAID rebuild for a single bad drive "should" be an XOR and should =
run at
>> 200,000 kb/sec (the default speed_limit_max).  I might be wrong on thi=
s and
>> this might still need a full RAID-6 syndrome compute, but I dont think=
 so.
>>
>> The rebuild might not hit 200MB/sec if the drive you replaced is
>> "conditioned".  Be sure to secure erase any non-new drive before you r=
eplace
>> it.
>>
>> Your read IOPS will compete with now busy drives which may increase th=
e IO
>> latency a lot, and slow you down a lot.
>>
>> One out of 22 read OPS will be to the bad drive, so this will now take=
 22
>> reads to re-construct the IO.  The reconstruction is XOR, so pretty ch=
eap
>> from a CPU point of view.  Regardless, your IOPS total will double.
>>
>> You can probably mitigate the amount of degradation by lowering the re=
build
>> speed, but this will make the rebuild take longer, so you are messed u=
p
>> either way.  If the server has "down time" at night, you might lower t=
he
>> rebuild to a really small value during the day, and up it at night.
>=20
> OK, right now I'm looking purely at performance in a degraded state,
> no rebuild taking place.
>=20
> We have designed a simple read load test to simulate the actual
> production workload.  (It's not perfect of course, but a reasonable
> approximation.  I can share with the list if there's interest.)  But
> basically it just runs multiple threads of reading random files
> continuously.
>=20
> When the array is in a pristine state, we can achieve read throughput
> of 8000 MB/sec (at the array level, per iostat with 5 second samples).
>=20
> Now I failed a single drive.  Running the same test, read performance
> drops all the way down to 200 MB/sec.
>=20
> I understand that IOPS should double, which to me says we should
> expect a roughly 50% read performance drop (napkin math).  But this is
> a drop of over 95%.
>=20
> Again, this is with no rebuild taking place...
>=20
> Thoughts?

This depends a lot on how you structured your raid array.  I didn't see
your earlier emails, so I'm inferring from the "one out of 22 reads will
be to the bad drive" that you have a 24 disk raid6 array?  If so, then
that's 22 data disks and 2 parity disks per stripe.  I'm gonna use that
as the basis for my next statement even if it's slightly wrong.

Doug was right in that you will have to read 21 data disks and 1 parity
disk to reconstruct reads from the missing block of any given stripe.
And while he is also correct that this doubles IO ops needed to get your
read data, it doesn't address the XOR load to get your data.  With 19
data disks and 1 parity disk, and say a 64k chunk size, you have to XOR
20 64k data blocks for 1 result.  If you are getting 200MB/s, you are
actually achieving more like 390MB/s of data read, with 190MB/s of it
being direct reads, and then you are using XOR on 200MB/s in order to
generate the other 10MB/s of results.

The question of why that performance is so bad is probably (and I say
probably because without actually testing it this is just some hand-wavy
explanation based upon what I've tested and found in the past, but may
not be true today) due to a couple factors:

1) 200MB/s of XOR is not insignificant.  Due to our single thread XOR
routines, you can actually keep a CPU pretty busy with this.  Also, even
though the XOR routines try to time their assembly 'just so' so that
they can use the cache avoiding instructions, this fails more often than
not so you end up blowing CPU caches while doing this work, which of
course effects the overall system.  Possible fixes for this might include=
:
	a) Multi-threaded XOR becoming the default (last I knew it wasn't,
correct me if I'm wrong)
	b) Improved XOR routines that deal with cache more intelligently
	c) Creating a consolidated page cache/stripe cache (if we can read more
of the blocks needed to get our data from cache instead of disk it helps
reduce that IO ops issue)
	d) Rearchitecting your arrays into raid50 instead of big raid6 array

2) Even though we theoretically doubled IO ops, we haven't addressed
whether or not that doubling is done efficiently.  Testing would be
warranted here to make sure that our reads for reconstruction aren't
negatively impacting overall disk IO op capability.  We might be doing
something that we can fix, such as interfering with merges or with
ordering or with latency sensitive commands.  A person would need to do
some deep inspection of how commands are being created and sent to each
device in order to see if we are keeping them busy or our own latencies
at the kernel level are leaving the disks idle and killing our overall
throughput (or conversely has the random head seeks just gone so
radically through the roof that the problem here really is the time it
takes the heads to travel everywhere we are sending them).


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--WfSVMDVmHOgF6NCO7l7SPuPOAGEaoV1uq--

--3b7lOEtCA7osNvvhdtmhB9lPlKvEC2vrv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvI8hAAoJELgmozMOVy/dGPkP/06q3qS0QQthsvQ1S7qbWFQz
+mufTcjP6xQE48nfeWaRZoX4D3rSOrV5xib7HGrzkGqIm1HAKXEVqwmDdz1TUCGb
psCebEnEyzdArcnsT6wRqs0eL3WbEQMLDCR8MmJKynB/OJFXgSi90J4nN2buXN0J
6DGQZ33wskj1Jq+8jy5rQHQNzCzRkx7KHV3NrECk+/BOIjeerZ9ulxirx+fZ0imn
orbuoi6nW144TBA+1fYcnK1/zn7qKJioOUds8/e/jUraRAHWK79Wn+5Jjt769idf
EyV/LMkvtxt0wQQJarcLo/5ONB+e7kGPBsOhVXrFruqqFpiXrourDPVNvM8oHBRL
lar2Cs4TtrgfR1IrxiqFKcE9vSn+du40FwTR7WShw3DlQCV+NoAB0JdL7bJJdtgd
WTmb+chCxdkc24LoHVNIF5iuUf561bnf6X4MAacDd3WC9YN57SlsXSg8KVoEkaeW
HKbfa9aznzY95Lw4HTDMilJIgkfehJMK0IzU1FRFJL94aMtnHqxXbjUiniGYqtum
H6RoJW28iD3HscQTKRUNcay3ewSCrY4AjKoIc3vQ/Ixua0sPXPC3eRmQeb6tvwNO
VfgQiB6uCwkoc/3VhopKMyC2ak5Um7MIJZ1Ns/qJI0Lu5ESt5+L9pSfPbKJrhROr
LN6A+94CkyJw+Svph2mK
=W5Wh
-----END PGP SIGNATURE-----

--3b7lOEtCA7osNvvhdtmhB9lPlKvEC2vrv--
