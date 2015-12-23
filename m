From: NeilBrown <neilb@suse.com>
Subject: Re: RAID10 Write Performance
Date: Thu, 24 Dec 2015 09:58:32 +1100
Message-ID: <87a8p022nb.fsf@notabene.neil.brown.name>
References: <CAHkw+LdtZY=d6kCtaTe5Uu8nNXOgF+yCAjJeHWJ2TrVAuNoDeA@mail.gmail.com> <CAHkw+LeVkGo8cOGMzQbq7sGtw5K9bc3CMOvurL0kjDf0ZWTfsA@mail.gmail.com> <87wps529dq.fsf@notabene.neil.brown.name> <CAHkw+LcTafoUeXbw8rdUwFi5a1oW=q-6uosa1uzaFjiYDYneaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+LcTafoUeXbw8rdUwFi5a1oW=q-6uosa1uzaFjiYDYneaA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 24 2015, Marc Smith wrote:

> Okay, thanks, I'll turn it back on and try some different chunk sizes.
>
> For my own knowledge, why/what is taking place under the covers that
> causes this behavior? When testing with fio, it sometimes takes 1-2
> minutes of "ramp up time" before the performance numbers are
> good/expected (when the write-intent bitmap is enabled).
>

Whenever md needs to write to a region (a bitmap-chunk) of the array
that it hasn't written to recently, it needs to set a bit and write out
the bitmap first.  It tries to gather multiple writes together and set
several bits at once, but a synchronous workload will defeat that.
Once the bit is set it will stay set until several seconds after the
last write.  I think it defaults to 5 seconds.
  mdadm -X /dev/some-component
will list it as 'daemon sleep'.

So the delay you are seeing is the time it takes to get all of those
bits set.  1 minute does sound like a long time, though it the writes
are synchronous that would easily explain it.
With a larger chunk size, there are fewer bits to set so fewer time that
the drives need to seek to the other end of the disk to write out the
bitmap.

If you run "watch -n 0.1 mdadm -X /dev/something" in a window it will
report how many bits are set moment by moment.  That might give you some
feel for what is happening.

NeilBrown



>
> Thanks,
>
> Marc
>
>
> On Tue, Dec 22, 2015 at 9:20 PM, NeilBrown <neilb@suse.com> wrote:
>> On Wed, Dec 23 2015, Marc Smith wrote:
>>
>>> Solved... appears it was the write-intent bitmap that caused the
>>> performance issues. I discovered if I left the test running longer
>>> than 60 seconds, the performance would eventually climb to where I'd
>>> expect it. I ran 'mdadm --grow --bitmap=none /dev/md0' and now random
>>> write performance is high/good/stable right off the bat.
>>
>> Keeping a write-intent bitmap really is a good idea.
>> Using a larger bitmap chunk size can reduce the performance penalty and
>> preserve much of the value.  It is easy enough to experiment with
>> different sizes.
>>
>> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeycYAAoJEDnsnt1WYoG5XhgP/0dCufS/poOtTxKd+JFwDGG9
6wVfmmMyn9Rv6G2jTy0fw7Gf6juP3NxhV0TKQtcTzGnLjcW9L5OZu8mtERUt3MIJ
TvQfcjEcLsk02r31+H+0yqI33pPaVxm7i5E7PY/cqn08ywu7mNglxkHIXTnGyR2u
1vxnxFIScMP/mq5utqIE/LVl0+3HQLFwddj86gM9F75sbY2OKdFTXz0yHhN/TS//
d8MMrtSsYTQ+G85ZJlp1EDgmI4AQIwhIWl0d0GBltiVTUmGnpYkgcLQCtuhEMdD2
qggZvskda2c7qk4j2poH6ELXV0c9Wo7gzRNLykFuFkS9JCC9QTfamkTeH2/3o9oU
z8yIbmCo/jOU7QdhuZRRW0qzpi18T2Z7c9ge5GcLLCDmUbEtAzhEfKWAtCdRInNE
1rGWnw8zxrNt0W04llsrKCYshiNuMhhUxNmgkZZaTBiomgmlEnOJXgiAXmuO2d1j
+0L35i/TiR4IZjGib91W0jIAQlC95DVHgAJufY6c9vP7eZbB8IU4ljmhrw92d0es
iKJUFHTmew120fzI5QY2Bwy5JtAxHexj/rhLkI9qPBCk3SAAhl0rWOCgNTBm4W/r
BCBFqtfWmHo2XqaWSE5YUyoJpl7Pn6y4XC+XToBENmWk+lKixDWohLTbj1sGInsx
Q/CuKGhnGhdJE2fMWkR0
=WK9b
-----END PGP SIGNATURE-----
--=-=-=--
