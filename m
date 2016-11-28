From: NeilBrown <neilb@suse.com>
Subject: Re: raid0 vs. mkfs
Date: Mon, 28 Nov 2016 16:09:46 +1100
Message-ID: <87oa108a1x.fsf@notabene.neil.brown.name>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 28 2016, Avi Kivity wrote:

> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large=20
> disk that supports TRIM/DISCARD (erase whichever is inappropriate).=20=20
> That is because mkfs issues a TRIM/DISCARD (erase whichever is=20
> inappropriate) for the entire partition. As far as I can tell, md=20
> converts the large TRIM/DISCARD (erase whichever is inappropriate) into=20
> a large number of TRIM/DISCARD (erase whichever is inappropriate)=20
> requests, one per chunk-size worth of disk, and issues them to the RAID=20
> components individually.
>
>
> It seems to me that md can convert the large TRIM/DISCARD (erase=20
> whichever is inappropriate) request it gets into one TRIM/DISCARD (erase=
=20
> whichever is inappropriate) per RAID component, converting an O(disk=20
> size / chunk size) operation into an O(number of RAID components)=20
> operation, which is much faster.
>
>
> I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, with=20
> the operation taking about a quarter of an hour, continuously pushing=20
> half-megabyte TRIM/DISCARD (erase whichever is inappropriate) requests=20
> to the disk. Linux 4.1.12.

Surely it is the task of the underlying driver, or the queuing
infrastructure, to merge small requests into large requests.
Why should this have anything do to with RAID0?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlg7vBoACgkQOeye3VZi
gbmhcA/+PNdmkhKZuAkl2w6JnXbY1ilfMifpOQsxXo8Rd/+TdqYE6OtQNlMEhJ1z
yRiqn7H9exlMUo5vIYGCvjqFxuarih5+OmhlorZ4wWnlvIH4soJfIqiGCKJ+5/2x
PBfuJeOxFpYzuJaMzpBFg8+lg9M8DnnhtNegyvSd47PK1K6yp57ddznxnxTkbv54
1BOA8h/6x9qZOHYhc5UK1LFaPuKU6tFlQfx0EShvqzIXnWf+NJv7e1rVjTAvp5LL
0cIfyMda9U2LlWjbJ3R4azrmUV/J30IDpvXcyzAsVy7wrgcJADBjRBBZS1wUVwcz
6OL+o7jft11M3r771wX26b9ICYKX8/ETbZ89AN/UkCvrtQh3PJFTmlni5CYPEeW+
z1+NBG4ML96DylMQphsyDMgyJYjFbX2iX9OYsl9Adl1cI1HQalSSWM9d28SPQTSM
14As7r7iByxpgvOIDKoUj6TH6jn0ktUMaMF2jqn1++mS3HUJkWRvnTKX6ilAy1hA
Ijz6cepMU5Sctneift6cSZyxwkt718VywhaWRVKIqGk3NY2KuqSpugg3QsLE6j/m
0KkoztxA0dB/LITWcuoICgFPK0wqW9kbVAcmsUNMhLGTT1tb3slI/zs9HM+pTNPr
2tADH/OOMBUClBF/HySIvZQKrRwpLfcTcB9sj3SaE92BdU1jxzQ=
=/tZ1
-----END PGP SIGNATURE-----
--=-=-=--
