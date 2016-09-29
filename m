From: NeilBrown <neilb@suse.com>
Subject: Re: moving spares into group and checking spares
Date: Thu, 29 Sep 2016 11:17:53 +1000
Message-ID: <878tub7bcu.fsf@notabene.neil.brown.name>
References: <nramjg$n07$1@blaine.gmane.org> <20160914092959.GA3584@metamorpher.de> <nrc2pm$2a9$1@blaine.gmane.org> <20160914232249.6e5fc568@natsu> <nrce27$2km$1@blaine.gmane.org> <CAJCQCtQJwOTYsWubd0rV-6PRL4kmVRKLfLr3=7ZPr1Zb3SrwtQ@mail.gmail.com> <nrckp2$k8e$1@blaine.gmane.org> <CAJCQCtQ1GHdQtShbW3U1o-fmXhT3fHrC7S9BxsxrrOG=0H_p3A@mail.gmail.com> <nrd5ak$e8c$1@blaine.gmane.org> <CAJCQCtRW9REafzmyk+W6aVxqxMUWCdXNkrST1e7udrH-zp26Uw@mail.gmail.com> <nsf29k$f6s$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <nsf29k$f6s$1@blaine.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: scar <scar@drigon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 28 2016, scar wrote:

> Chris Murphy wrote on 09/14/2016 08:51 PM:
>> On Wed, Sep 14, 2016 at 9:42 PM, scar <scar@drigon.com> wrote:
>>
>>> 00 80 00
>>> Sep 12 08:05:34 hind kernel: [1350051.023847] end_request: critical med=
ium
>>> error, dev sdk, sector 598457896
>>> Sep 12 08:05:35 hind kernel: [1350051.385810] md/raid:md0: read error
>>> corrected (8 sectors at 598455848 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385826] md/raid:md0: read error
>>> corrected (8 sectors at 598455856 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385834] md/raid:md0: read error
>>> corrected (8 sectors at 598455864 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385840] md/raid:md0: read error
>>> corrected (8 sectors at 598455872 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385847] md/raid:md0: read error
>>> corrected (8 sectors at 598455880 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385853] md/raid:md0: read error
>>> corrected (8 sectors at 598455888 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385859] md/raid:md0: read error
>>> corrected (8 sectors at 598455896 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385865] md/raid:md0: read error
>>> corrected (8 sectors at 598455904 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385873] md/raid:md0: read error
>>> corrected (8 sectors at 598455912 on sdk1)
>>> Sep 12 08:05:35 hind kernel: [1350051.385880] md/raid:md0: read error
>>> corrected (8 sectors at 598455920 on sdk1)
>>> Sep 12 13:39:43 hind kernel: [1370087.022160] md: md0: data-check done.
>>>
>>>
>>> so it seems to be working?  although the sector reported by libata is
>>> different than what md corrected
>>
>> Looks like it replaced the entire chunk that includes the bad sector.
>> Is the chunk size 32KiB?
>>
>
> No it is 512K, and the sector reported by libata is almost 2000 sectors=20
> different than what mdadm reported

The difference is probably the Data Offset.
libata reports a sector in the device.
md reports a sector in the data section of the device.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX7GvCAAoJEDnsnt1WYoG5JrAQALUnhHbAeSyJtyKXJDWU+4oN
CzEwBTzQF8xOYEDf1QZ0Yxeyl4Kq99coCCLHKFN5s2dqtITaADe9FRateyDxBX2o
F47FwCfFYctLkxt1bTOMicm9knp1VD6qKsv+gpvV9BZ7jT678oJDlxE2ly9w8POc
shCitqN2txumRt+3pF3pG62CnxqSWD5+Eka/0x9DHW8yILPGijWl0QykfHTt+zpS
iK0Yqwarsj5ldzL4EEwgSL8urr4CVuDx5k9xXmpjs6u8SYUEs/WcQrR/thnT5iQV
8FK6B+PiIjTf8kNTaskljWBlBvIIoCMde04onltjhKv7Hw/4JjknP0mHTBjeD3Xg
4PPqmHmcf6ArGWVYAQJBJ39tcuRKWEo7xzTg/sz4gBhPNkHcEgt+EqRLgue2HSem
1/8ChI8ck4fhVKhRucjsWezo2gQ75av38kLCTEcB+cPGJUDJrwMQiu1Ddcz1mxER
D6UDQYvRdQvrWbnN8zqxF/q08KUhnBwArOdnDuoLJ/E97Qk9pFKHS9PgqdXG8pD9
QJLY8SayhXts3DoQgav2fY0ktZDlur2npEfgSq/I1+t3xKcg71JCKRDcVjLQq6so
ESyimlPRMPc2x6I421nJS0+eNklxhiPZMLJlUspZIPc5PMa1lO0bXGMUtQ/Ty1Bk
cOCGXMugizyCvLdjVUyu
=VyUr
-----END PGP SIGNATURE-----
--=-=-=--
