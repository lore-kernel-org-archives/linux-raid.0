From: Brad Campbell <brad@wasp.net.au>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Wed, 17 Nov 2004 15:44:04 +0400
Message-ID: <419B3984.4060601@wasp.net.au>
References: <200411132039.iADKdDN07474@www.watkins-home.com>	<41968282.6060306@dgreaves.com> <4198DF79.8080809@dgreaves.com>	<41999A9B.2000907@wasp.net.au> <419B3435.3080707@dgreaves.com> <yw1x4qjog1lf.fsf@ford.inprovide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1x4qjog1lf.fsf@ford.inprovide.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Cc: David Greaves <david@dgreaves.com>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

M=E5ns Rullg=E5rd wrote:
> David Greaves <david@dgreaves.com> writes:
>=20
>=20
>>I've been tracking this on the ide list and I've been nervous of
>>applying anything since I don't have proper  backups. I'm relying on
>>redundancy.
>=20
>
> RAID can *never* replace proper backups.  RAID only protects against
> low-level disk failures.  Filesystem corruption caused by bugs,
> accidental deleting of files, etc. are happily allowed.  Get a DVD
> burner, you'll thank yourself one day.
>=20

Heh. I have 2.5TB here. Thats a lot of DVD's.
I have the whole lot set chmod a-w and rely on RAID to keep me alive. (=
Having said it is a home=20
entertainment system and would not cause mega dollar industrial damage =
if I lost it). All my=20
original media is about 9,000km away but I could survive until I re-rip=
ped it.

I slide my array drives out and slide in some throwaway spares to beat =
on for testing before I=20
deploy a new kernel.

David Greaves wrote:

>=20
> I looked to see what I'd need to do and given I'm running 2.6.9 I tak=
e it I'd have to apply:
> =20
> http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/2.6.9-li=
bata1-dev1.patch.bz2
> which depends on
> =20
> http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/2.6.9-li=
bata1.patch.bz2
>=20
> That seems like quite a lot and I'm not clear on the level of stabili=
ty impact on my system.
>=20
> Now although I track linux-ide I doubt I'm fully informed!!
> So if anyone would like to inform me of a reasonable course of action=
 then I'm actually reasonably happy to apply the SMART patch.

That is pretty close. I actually just cloned the kernel bk tree and pul=
led both of Jeffs trees, but=20
then I ran about 10 hours of super intensive tests with 5 spare drives =
spread across my 3=20
controllers before I slid my 13 raid disks back in and let it loose. I =
guess my real kernel version=20
is somewhere around 2.6.10-rc1-bk3.

Have had good luck with it over the last couple of weeks and I have bee=
n hitting it pretty hard.=20
But, as I said before, I'm on a UP machine. Andy pointed out some possi=
ble issues on SMP so beware=20
there.

Brad
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
