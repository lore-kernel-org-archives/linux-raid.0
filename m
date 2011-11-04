From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Impending failure?
Date: Fri, 4 Nov 2011 15:43:07 +0000
Message-ID: <CADNH=7G0jxirzj+T-YcqJ+AaF6LFEvJMBv+RfFYT4fxD8VpYww@mail.gmail.com>
References: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
	<alpine.DEB.2.00.1111041529150.19721@uplift.swm.pp.se>
	<CAB1R3si1BObUpb7iwcS0D2EGd-_Spw4nuBLPxnPBf9he+zuHzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3si1BObUpb7iwcS0D2EGd-_Spw4nuBLPxnPBf9he+zuHzA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4 November 2011 15:31, Alex <mysqlstudent@gmail.com> wrote:
> Hi,
>
>>> Can you point me to instructions on the best way to replace a disk?
>>
>> First run "repair" on the array, hopefully it'll notice the unreadab=
le
>> blocks and re-write them.
>>
>> echo repair >> /sys/block/md0/md/sync_action
>>
>> Also make sure your OS does regular scrubs of the raid, usually this=
 is done
>> by monthly runs of checkarray, this is an example from Ubuntu:
>
> Great, thanks. I recalled something like that, but couldn't remember =
exactly.
>
> The system passed the above rebuild test on both arrays, but I'm
> obviously still concerned about the disk. Here are the relevant
> smartctl lines:
>
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE
> UPDATED =C2=A0WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000f =C2=A0 108 =C2=A0 08=
9 =C2=A0 006 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0003 =
=C2=A0 094 =C2=A0 094 =C2=A0 000 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 29
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 036 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000f =C2=A0 083=
 =C2=A0 060 =C2=A0 030 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 209739855
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 074 =C2=A0 074 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 22816
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0013 =C2=A0 10=
0 =C2=A0 100 =C2=A0 097 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 020 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 37
> 187 Reported_Uncorrect =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 095 =C2=A0 0=
95 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 5
> 189 High_Fly_Writes =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x003a =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 190 Airflow_Temperature_Cel 0x0022 =C2=A0 075 =C2=A0 064 =C2=A0 045 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 25 (Min/Max 23/32)
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 025 =C2=A0 040 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 25 (0 18 0 0)
> 195 Hardware_ECC_Recovered =C2=A00x001a =C2=A0 057 =C2=A0 045 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 51009302
> 197 Current_Pending_Sector =C2=A00x0012 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 2
> 198 Offline_Uncorrectable =C2=A0 0x0010 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 2
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x003e =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x0000 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 202 Data_Address_Mark_Errs =C2=A00x0032 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>
> Pending_sector and uncorrectable are both greater than zero. Is this
> drive on its way to failure?
>
> Can someone point me to the proper mdadm commands to set the drive
> faulty then rebuild it after installing the new one?
>
> Thanks again,
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

187 Reported_Uncorrect      0x0032   095   095   000    Old_age
Always       -       5
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       2
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       2

This tells me to get rid of the drive. I don't know the mdadm commands
from my head, sorry, but it's in the man page(s). If you want you run
a scrub and see if these numbers change. If the drive fails hard
enough then md will kick it out of the array anyway. Btw, I scrub my
RAID6 (7 HDDs) once a week.

/Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
