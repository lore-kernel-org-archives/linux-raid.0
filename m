From: NeilBrown <neilb@suse.de>
Subject: Re: Automatically drop caches after mdadm fails a drive out of an
 array?
Date: Wed, 12 Feb 2014 06:54:20 +1100
Message-ID: <20140212065420.4643f9a1@notabene.brown>
References: <1413719638.30344.1392138285471.JavaMail.zimbra@xes-inc.com>
	<1090802800.32078.1392138664718.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zICaYjEvCuPzQlHDTgCRyL9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1090802800.32078.1392138664718.JavaMail.zimbra@xes-inc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Martin <amartin@xes-inc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zICaYjEvCuPzQlHDTgCRyL9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Feb 2014 11:11:04 -0600 (CST) Andrew Martin <amartin@xes-inc.com>
wrote:

> Hello,
>=20
> I am running mdadm 3.2.5 on an Ubuntu 12.04 fileserver with a 10-drive RA=
ID6 array (10x1TB). Recently, /dev/sdb started failing:
> Feb 10 13:49:29 myfileserver kernel: [17162220.838256] sas: command 0xfff=
f88010628f600, task 0xffff8800466241c0, timed out: BLK_EH_NOT_HANDLED
>=20
> Around this same time, a few users attempted to access a directory on thi=
s RAID array over CIFS, which they had previously accessed earlier in the d=
ay. When they attempted to access it this time, the directory was empty. Th=
e emptiness of the folder was confirmed via a local shell on the fileserver=
, which reported the same information. At around 13:50, mdadm dropped /dev/=
sdb from the RAID array:

The directory being empty can have nothing to do with the device failure.
md/raid will never let bad data into the page cache in the manner you sugge=
st.

I cannot explain to you what happened, but I'm absolutely certain it wasn't
something that could be fixed by md dropping any caches.

NeilBrown


> Feb 10 13:50:31 myfileserver mdadm[1897]: Fail event detected on md devic=
e /dev/md2, component device /dev/sdb
>=20
> However, it was not until around 14:15 that these files reappeared in the=
 directory. I am guessing that it took this long for the invalid, cached re=
ad to be flushed from the kernel buffer cache.
>=20
> The concern with the above behavior is it leaves a potentially large wind=
ow of time during which certain data may not be correctly returned from the=
 RAID array. Is it possible for mdadm to automatically flush the kernel buf=
fer cache after it drops a drive from the array:
> sync; echo 3 > /proc/sys/vm/drop_caches
>=20
> This would have caused the data to have been re-read at 13:50, a much sma=
ller window of time during which invalid data was present in the cache. Or,=
 is there a better suggestion for handling this situation?
>=20
> Thanks,
>=20
> Andrew Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/zICaYjEvCuPzQlHDTgCRyL9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUvp/7Dnsnt1WYoG5AQL//BAAgklWeHIxAdlU7XjEdIvAG6GF5arETp3C
we6BWWxcD/EaNM3mAvnEWTF5iHk26sfqhNAWRxWRT5S6x+ZAbO0fSLPNUvZALPeB
ivW9ygPRQyrxxpck88E7nPkcSi1kaKSDK/ObXH4bYes/+XF22NACmwp5jQYDT4VX
mmYjqRDPlvouDZZirKQziSSgiOYj1ZqxFW0zHUg5B3XlpO+9RsR8ALvat1XjWjAt
ZIl1yINF90yZ+/2YH7SIKJ1VS1kvIMzp5eaJgDJGvOiWLeV/VVJWZ0NRj0f3kpkX
ao2zRAh/Ew/Q06NsiQZBjp4P99I+IKku5f6LvThHfX+Kyp8d5Jck6jo1tHrPU9NJ
AwLpZhw+B8qihFK9iRaBL+w2RtxzKFJLaGnUJaleRm9/7lomGdDnQynUolg5olQi
C1pqUCQdsF+x28tpY0MJ/OZW6i660t+M5hId+ugjQajZs0UA8aT5CxW0dlZ6OGNe
JddC3fjAqMqHCUYD8IpUpLhdIM5nu6WfmI9BYW36IAxWENKtT5P7MqDrjHkrkTzf
xeJbWH+rH7DyQILhKRgSQZ9VEEd4qh1J8HcfVtqMrkiGjOMd2Q3fbhRoWm32imLB
Ivk781OvtuLSxLe5fK5oA6Y/8x4K+v3y8XBkMyRgvhor5xydkfcHeMLQoJR4SLgT
a8runxrPkrs=
=CdqQ
-----END PGP SIGNATURE-----

--Sig_/zICaYjEvCuPzQlHDTgCRyL9--
