From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Mon, 21 Dec 2015 09:59:48 +1100
Message-ID: <87vb7s680r.fsf@notabene.neil.brown.name>
References: <1450390197-19479-1-git-send-email-hch@lst.de> <1450390197-19479-4-git-send-email-hch@lst.de> <20151217234748.GA1860175@devbig084.prn1.facebook.com> <874mfg8qyc.fsf@notabene.neil.brown.name> <20151218015847.GA2146501@devbig084.prn1.facebook.com> <20151218112535.GB28224@lst.de> <20151218230657.GA342953@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151218230657.GA342953@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 19 2015, Shaohua Li wrote:

> On Fri, Dec 18, 2015 at 12:25:35PM +0100, Christoph Hellwig wrote:
>> [can you trim your replies please?  I had to trim almost 150 lines of
>>  junk before getting to your reply!]
>>=20
>> > >  	spin_unlock_irqrestore(&log->io_list_lock, flags);
>> > >=20
>> > > or is that too simplistic?
>> >=20
>> > maybe add a new list and run the list at the begining of r5l_do_reclai=
m().
>>=20
>> What's the advantage of another list?
>
> I mean simply waking up reclaim thread doesn't work as r5l_do_reclaim()
> will return if reclaimable =3D=3D 0. There is no guarantee reclaimable sp=
ace
> is available in the allocation failure. So we'd better move the retry at
> the begining of r5l_do_reclaim(). If yes, we can't reuse the
> no_space_stripes list.

They certainly are conceptually different lists.  Whether the same
linked list can be used for both is an engineering question.

One list is for updates that cannot be handled yet because the log is
full.  Once the head of the log is cleared and the start pointer
updated, those requests can be handled (or some of them can).

The other list is for updates that cannot be handled yet because a
kmalloc failed.  There is no clear trigger for when to handle those
again so we would need to retry quite frequently.  It would be easy to
miss retrying in rare circumstances...

I wonder if we should have a mempool for these io units too.
We would allocate with GFP_ATOMIC (or similar) so the allocation woult
fail instead of blocking, but we would then know that an allocation
could only fail if there was another request in flight.  So the place
where we free an io_unit would be the obviously correct place to trigger
a retry of the delayed-due-to-mem-allocation-failure stripes.

So I think I would prefer two lists, another mempool, and very well
defined places to retry the two lists.  Is that over-engineering?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWdzLkAAoJEDnsnt1WYoG5jswQAIqZYMc8FErLC0xFPj0eeGCc
E2g/sFhvUDhKQYJny3IbhX5E4sOT29Y+p/pdt/Il64p1mm+yqvHLZ6izoYq9OO3y
72bG05tBmeq6HRvMv/vcVplnZv+9euM1LYF8+tma2XcV5klSIfMfn2QunYJiy0b9
Pq0Q+K2uXZW8bzE3wI16+xS2WZQZ4pn7gHb4d0Hto+EXBvEEwZV5Icg148+/Kf7Q
Y5n8wt9Pxh9rEEaHcE72Z5EpubiSU4sj3eyMOxz5XT8RSo725PAvsW+v5yhdPict
94IHMqzkI5X846M50sg+yYIolRve7WFdZP7J4KwaPCWNCtq0aWghp15sXWXEe3OP
2/DhD5Jzidb54e52oIbAUzx+WCEkMpfpSI1bkLCmiBuS38FxPTPD1fpk//Ml3mE4
wU5+4u3DS4AzwNhxOUlHeaYnKROhHXFJNf97l5nV/cv8XDYfj3dJbqq04Jqg27xD
tbSh54X3sIrwwg0jnjd6bkwxUxHN1akBTRTYue1q0WJhdERtb6dWzzXi1hPcbYiB
Wt/Hus/3yvUc8ylxRO3FwPOFzavcEM0Uoio6d5/is9KR4OISSZSRkMeQPYUq4uFp
fXFUygBRXlTUGTxZrFA7CDDEwSAeE7DR6rECXZXYE/IOZ4lituuqjuqFO050avDU
3ZY5R/FC9douzuBjUS8n
=h7Tg
-----END PGP SIGNATURE-----
--=-=-=--
