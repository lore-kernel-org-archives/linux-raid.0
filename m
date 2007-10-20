From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid1/5 over iSCSI trouble
Date: Sat, 20 Oct 2007 09:52:17 +0200
Message-ID: <4719B3B1.90509@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com>	 <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>	 <47181CB2.1060602@tmr.com>  <471864F8.9010209@systella.fr> <1192809103.30976.11.camel@dwillia2-linux.ch.intel.com> <4718DE66.8000905@tmr.com> <471916B5.6080709@systella.fr> <47191855.4020402@systella.fr> <47191BCF.2000908@systella.fr> <471942D2.3070609@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <471942D2.3070609@tmr.com>
Sender: sparclinux-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, sparclinux@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net
List-Id: linux-raid.ids

Bill Davidsen wrote:
> BERTRAND Jo=C3=ABl wrote:
>>
>>     Sorry for this last mail. I have found another mistake, but I=20
>> don't know if this bug comes from iscsi-target or raid5 itself. iSCS=
I=20
>> target is disconnected because istd1 and md_d0_raid5 kernel threads=20
>> use 100% of CPU each !
>>
>> Tasks: 235 total,   6 running, 227 sleeping,   0 stopped,   2 zombie
>> Cpu(s):  0.1%us, 12.5%sy,  0.0%ni, 87.4%id,  0.0%wa,  0.0%hi,  0.0%s=
i,=20
>> 0.0%st
>> Mem:   4139032k total,   218424k used,  3920608k free,    10136k buf=
fers
>> Swap:  7815536k total,        0k used,  7815536k free,    64808k cac=
hed
>>
>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>  5824 root      15  -5     0    0    0 R  100  0.0  10:34.25 istd1
>>  5599 root      15  -5     0    0    0 R  100  0.0   7:25.43 md_d0_r=
aid5
>=20
> Given that the summary shows 87.4% idle, something is not right. You=20
> might try another tool, like vmstat, to at least verify the way the C=
PU=20
> is being used. When you can't trust what your tools tell you it gets=20
> really hard to make decisions based on the data.

	Don't forget this box is a 32-CPU server.

	JKB
-
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
