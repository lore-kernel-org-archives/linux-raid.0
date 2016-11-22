From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Tue, 22 Nov 2016 11:25:04 +1100
Message-ID: <87mvgscqe7.fsf@notabene.neil.brown.name>
References: <147969099621.5434.12384452255155063186.stgit@noble> <20161121234311.6qhwa2g3oa4uhcbi@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161121234311.6qhwa2g3oa4uhcbi@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22 2016, Shaohua Li wrote:

> On Mon, Nov 21, 2016 at 12:19:43PM +1100, Neil Brown wrote:
>> There are 2 problems with using bi_phys_segments as a counter
>> 1/ we only use 16bits, which limits bios to 256M
>> 2/ it is poor form to reuse a field like this.  It interferes
>>    with other changes to bios.
>>=20
>> We need to clean up a few things before we can change the use the
>> counter which is now available inside a bio.
>>=20
>> I have only tested this lightly.  More review and testing would be
>> appreciated.
>
> So without the accounting, we:
> - don't do bio completion trace

Yes, but hopefully that will be added back to bio_endio() soon.

> - call md_write_start/md_write_end excessively, which involves atomic ope=
ration.

raid5_inc_bio_active_stripes() did an atomic operation.  I don't think
there is a net increase in the number of atomic operations.

>
> Not big problems. But we are actually reusing __bi_remaining, I'm wonderi=
ng why
> we not explicitly reuse it. Eg, adds bio_dec_remaining_return() and uses =
it
> like raid5_dec_bi_active_stripes.

Because using it exactly the same way that other places use it leads to
fewer surprises, now or later.
And I think that the effort to rearrange the code so that we could just
call bio_endio() brought real improvements in code clarity and
simplicity.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYM5BgAAoJEDnsnt1WYoG56BEQAIZs5BxK7wVMpM1dY1dnK7Yb
XewjjiJrcSXvCexjyGBwgP0nDJ5XzlZBpsobcfbHlSWOh//eyS1wBZBq2kPeN5cJ
vQlt6z5s3OgzIMQAqTtIUdJuTJK+ZHk3ju1CUGkK5fPRyEsn4xJpzA8VpH5DQMEL
QnVHuLT5jSpBohcehCxiaTQ2WZgqSlasPpnO7Aa09jpADN8JeZIPALPTVvWLkdHY
7dh2hzZHR6iU9dF1tZiJdfG4g2dEmOGwillYbOJxgpTDIa8/CjMlj1R4iU/3UdlD
HW0UUAV7Pgu9cSlmeHVUpFxmA9ucH/G0junghycas82T/80sCAridfyVc2tc36ar
t6Rq+AWLpBGkkmItl2qdYf36BJiblobYevonxcHKe1CG4IVr9scmOB9vNwjzn3qf
xqNqIBSPI4/duWbqXfY4RtGWLVeHiSkYYNd3RzZXDQTTNZJrvb8Yit7/eap2eT2C
F7MLc/YEUgpcWA9g/SnP9CLlYLrIV880yAJfgI6jdYIH21J7Qs5dO233AO0w1lKU
TXam1MXdj6aPeptzy0Uidmh6bf+u7D/0peX4OfLqqXZw0se2gl81SZuEQpMAgFSB
FCPMOsTzQQuEbBDyZMfUdGySXqwC2WPXUwTpO54raNEzD4yKgLqrDKwtmDfMiPrU
tmwS5Qfne+kO0uuLgKvl
=Y7Yx
-----END PGP SIGNATURE-----
--=-=-=--
