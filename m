From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove resync window
Date: Fri, 24 Feb 2017 10:14:11 +1100
Message-ID: <87lgswqz3w.fsf@notabene.neil.brown.name>
References: <1487176523-109075-1-git-send-email-colyli@suse.de> <87shnevcpr.fsf@notabene.neil.brown.name> <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de> <87shn9spsy.fsf@notabene.neil.brown.name> <87k28lshg5.fsf@notabene.neil.brown.name> <20170220070430.4mca7clpaw7kpj4j@kernel.org> <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de> <878tp0s7w8.fsf@notabene.neil.brown.name> <f36e85b1-cca1-5be4-a171-d64057cc56a3@suse.de> <20170221174542.rer73ywil3oq26gj@kernel.org> <c04d68cd-96e8-dff9-c54e-54248394119f@suse.de> <488f88e0-8111-a320-3abb-c6e6611a957e@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <488f88e0-8111-a320-3abb-c6e6611a957e@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Feb 23 2017, Coly Li wrote:

>
> I tried to set up a 4 layer stacked md raid1, and reduce I/O barrier
> bucket size to 8MB, running for 10 hours, there is no deadlock observed,

Try setting BARRIER_BUCKETS_NR to '1' and BARRIER_UNIT_SECTOR_BITS to 3
and make sure the write requests are larger than 1 page (and have resync
happen at the same time as writes).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlivbMMACgkQOeye3VZi
gbnjIhAAhRs9ozq7WnfrgS9SZsISXRr2R7lDycDN9oeezcuSPdHEd/kCDDYEfYmP
/T4/OXWU0i0WnmAvHk1NcMt6ukHMoDC3ZnWb8p21gwmKqklG9L+p/QGyMTBqQ1ms
TOrNRkpVlIHfsOUXxPCGo0I0Jy698TJktPr5pFO9FvtLuIkFeRAU183v3U+5xWsR
/E5ph8ztb9wUWf2BmTIvQ6ouK2eXBV16m51hjEWapzqaZtCUGh7K+3EjUP7X5ok9
TfH4oqV58ez1K4AI51WE6iTCwVeNPvieCscd6+pa82gdYcZd2GQ6bWxeZCAkT8II
H+R1GA/aAXa68wiehpHstkWgPaS1jeOFDEZLp6h3WBfAuXOGfBgRwY/ab7nrLJb+
JbxrSw2GxKP30DT8bm1Nq6ieqMxche5V17yfQyCZW3ZcJ0GmT+zjot6fox88m86a
ntHV0orK9wVnFsE9QhYkTF1MQjbHqUo0mS0sAWc7EXbsJz1/21N1KO6zAClCs3Z8
Hp1kjNGjjdgoO2ib9xI0YiOrIXq3CqmTNTrwV06eAlHWtGH5KEkeRIxsXz56cvTp
vjwboRW5Jb3xA/4ZUNAdqMwxcTuxgf56VdrR6DHWNIGnxAtV019GDtL2kxgb+DFV
Cpm5IkHqVPQj/g6onpJwcT+CkPH0I6EyQozotxJZohdYegbOwS8=
=ouGj
-----END PGP SIGNATURE-----
--=-=-=--
