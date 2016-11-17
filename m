From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 2/4] md: add bio completion tracing for raid1/raid10
Date: Thu, 17 Nov 2016 16:35:47 +1100
Message-ID: <87r36ahdn0.fsf@notabene.neil.brown.name>
References: <147910131504.27168.6566119701315109161.stgit@noble> <147910142112.27168.16834874155342134173.stgit@noble> <20161116143233.GA28615@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161116143233.GA28615@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 17 2016, Christoph Hellwig wrote:

> On Mon, Nov 14, 2016 at 04:30:21PM +1100, NeilBrown wrote:
>> raid5 already has this, as does dm.
>> linear and raid0 do no see completions, only bio_chain_end() or bio_endi=
o()
>> see those.
>> So just add it for raid1 and raid10.
>>=20
>> Between
>>  Commit: 3a366e614d08 ("block: add missing block_bio_complete() tracepoi=
nt")
>> and
>>  Commit: 0a82a8d132b2 ("Revert "block: add missing block_bio_complete() =
tracepoint"")
>> in the 3.9-rc series, this was done centrally in bio_endio().
>> Until/unless that is resurected, do the tracing in the md/raid code.
>
> We're working on getting it back for 4.10, so please don't add these
> tracepoints to the MD driver for now.  Next time please also ask
> linux-block first and/or Cc the list on a patch like this.

Oh good, thanks for letting me know. I'll drop that one.
Do you know if there is any plan to include trace_block_split() in
bio_split()??

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLUGzAAoJEDnsnt1WYoG5RdoQAKbhK8zUYChVpAYnlR0Mnn8j
b9qKWmTntw/uc0QfC8mKxfRdlgzR4FM7UGK9v85+1/LgtdZHtnck2LYBTape4CvZ
mwcMcxPi/pGxtT6VWk9DxlCdyvSk46d4mz13s9CdEal3Gt0hN33HGPRQU66zf0CT
dOccGw3dKkTjuHuN00Rv6NBa/nIPd4CFh8vJ4hZ0IA1+u60AMsbQEzA74kNwYCRu
bLnm3hMpcS4tQ1Bp6JeeDV2VkogNC8cOyWtUJ+CXYCf/RO4d3J1ma6RzqSCQSbd0
JR8b6sjjE6BLvc0YZunLIsu1wbLuoobrU0pqVmbX2V2iWxG9Uqqkp0fkY/tHsp9Q
duBoplmgU/NJQwfFNHT/42iihvQTDiKgG1D8/4wLXqRH2NNvYXSHuXlmSjip4zT0
kWj0+w7P+HVbgKiwwkTQ5OKqfASRZfWYr2XSd38/6rknFqZshAHdJflOQz7JmRyj
ic96Ec3lgp5xlf87rwEOQjbDjVNnpe7lyn46XAlYn7RugfEVD6xFUtv+TYkOS4q/
3ETBTP0b2sx5D3m2AQvj2VfEgZYRXzfcpVNMF9h4dz3dEpK67HzokEpT8n1AsN1T
oxx2KLtPvcp+6Oe6aO36jDKo7KsNSzZwy7XqYKnQz7c9TzAj74nuJ3iFbk0bfLzy
s0nMWVuUXq29zQ2YI2py
=jK28
-----END PGP SIGNATURE-----
--=-=-=--
