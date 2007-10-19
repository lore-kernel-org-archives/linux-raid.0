From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid5 trouble
Date: Fri, 19 Oct 2007 22:42:29 +0200
Message-ID: <471916B5.6080709@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	 <47181CB2.1060602@tmr.com>  <471864F8.9010209@systella.fr> <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com> <4718DE66.8000905@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4718DE66.8000905@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Dan Williams wrote:
>> On Fri, 2007-10-19 at 01:04 -0700, BERTRAND Jo=C3=ABl wrote:
>>  =20
>>>         I run for 12 hours some dd's (read and write in nullio)
>>> between
>>> initiator and target without any disconnection. Thus iSCSI code see=
ms
>>> to
>>> be robust. Both initiator and target are alone on a single gigabit
>>> ethernet link (without any switch). I'm investigating...
>>>    =20
>>
>> Can you reproduce on 2.6.22?
>>
>> Also, I do not think this is the cause of your failure, but you have
>> CONFIG_DMA_ENGINE=3Dy in your config.  Setting this to 'n' will comp=
ile
>> out the unneeded checks for offload engines in async_memcpy and
>> async_xor.
>=20
> Given that offload engines are far less tested code, I think this is =
a=20
> very good thing to try!

	I'm trying wihtout CONFIG_DMA_ENGINE=3Dy. istd1 only uses 40% of one C=
PU=20
when I rebuild my raid1 array. 1% of this array was now resynchronized=20
without any hang.

Root gershwin:[/usr/scripts] > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md7 : active raid1 sdi1[2] md_d0p1[0]
       1464725632 blocks [2/1] [U_]
       [>....................]  recovery =3D  1.0% (15705536/1464725632=
)=20
finish=3D1103.9min speed=3D21875K/sec

	Regards,

	JKB
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
