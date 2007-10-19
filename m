From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid5 trouble
Date: Fri, 19 Oct 2007 18:03:00 +0200
Message-ID: <4718D534.4030503@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	 <47181CB2.1060602@tmr.com>  <471864F8.9010209@systella.fr> <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com>
Sender: sparclinux-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
> On Fri, 2007-10-19 at 01:04 -0700, BERTRAND Jo=C3=ABl wrote:
>>         I never see any oops with this patch. But I cannot create a
>> RAID1 array
>> with a local RAID5 volume and a foreign RAID5 array exported by iSCS=
I.
>> iSCSI seems to works fine, but RAID1 creation randomly aborts due to=
 a
>> unknown SCSI task on target side.
>=20
> For now I am going to forward this patch to Neil for inclusion in
> -stable and 2.6.24-rc.  I will add a "Tested-by: Jo=C3=ABl Bertrand
> <joel.bertrand@systella.fr>" unless you have an objection.

	No objection.

>>         I run for 12 hours some dd's (read and write in nullio)
>> between initiator and target without any disconnection. Thus iSCSI c=
ode seems
>> to be robust. Both initiator and target are alone on a single gigabi=
t
>> ethernet link (without any switch). I'm investigating...
>=20
> Can you reproduce on 2.6.22?

	I cannot downgrade these servers on 2.6.22 due to a bug in FUTEX code.

> Also, I do not think this is the cause of your failure, but you have
> CONFIG_DMA_ENGINE=3Dy in your config.  Setting this to 'n' will compi=
le
> out the unneeded checks for offload engines in async_memcpy and
> async_xor.

	I will try...

	Regards,

	JKB
-
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
