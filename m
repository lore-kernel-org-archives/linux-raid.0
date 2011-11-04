From: Peter Zieba <pzieba@networkmayhem.com>
Subject: Re: Impending failure?
Date: Fri, 4 Nov 2011 12:42:31 -0500 (CDT)
Message-ID: <de98e391-ec94-41eb-b83d-4535f51ac6e4@large-turd>
References: <CADNH=7G0jxirzj+T-YcqJ+AaF6LFEvJMBv+RfFYT4fxD8VpYww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7G0jxirzj+T-YcqJ+AaF6LFEvJMBv+RfFYT4fxD8VpYww@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?utf-8?Q?Bur=C3=A9n?= <mathias.buren@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org, Alex <mysqlstudent@gmail.com>
List-Id: linux-raid.ids

So, in my personal experience with pending sectors, it's worth mentioni=
ng the following:

If you do a "check", and you have any pending sectors that are within t=
he partition that is used for the md device, they should be read and re=
written as needed, causing the count to go down. However, I've noticed =
that sometimes I have pending sector counts on drives that don't go awa=
y after a "check". These would go away, however, if I failed and then r=
emoved the drive with mdadm, and then subsequently zero filled the /ent=
ire/ drive (as opposed to just the partition on that disk that is used =
by the array). The reason for this is that there's a small chunk of unu=
sed space that never gets read or written to right after the partition =
(even though I technically partition the entire drive as one large part=
ition (fd  Linux raid auto).

I think what actually happens in this case is that when the system read=
s data from near the end of the array, the drive itself will do read-ah=
ead and cache it. So, even though the computer never requested those ab=
andoned sectors, the drive eventually notices that it can't read them, =
and makes a note of the fact. So, this is harmless.

You could probably avoid the potential for false-positive on pending se=
ctors if you used the entire disk for the array (no partitions), but I'=
m pretty sure that breaks the raid auto-detection.

Currently, my main array has 8 2TB hitachi disks, in a raid 6. It is sc=
rubbed once a week, and one disk consistently has 8 pending sectors on =
it. I'm certain I could make those go away if I wanted, but, frankly, i=
t's purely aesthetic as far as I'm concerned. Some of my drives also ha=
ve non-zero "196 Reallocated_Event_Count" and "5 Reallocated_Sector_Ct"=
, however, I have no drives with non-zero "Offline_Uncorrectable". I ha=
ven't had any problems with the disks or array (other than a temperatur=
e induced failure ... but that's another story, and I still run the sam=
e disks after that event). I used to have lots of issues before I start=
ed scrubbing consistently.

Peter

----- Original Message -----
=46rom: "Mathias Bur=C3=A9n" <mathias.buren@gmail.com>
To: "Alex" <mysqlstudent@gmail.com>
Cc: "Mikael Abrahamsson" <swmike@swm.pp.se>, linux-raid@vger.kernel.org
Sent: Friday, November 4, 2011 10:43:07 AM
Subject: Re: Impending failure?

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
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
