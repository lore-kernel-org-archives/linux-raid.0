From: James <jtp@nc.rr.com>
Subject: Re: read errors corrected
Date: Thu, 30 Dec 2010 11:33:31 -0500
Message-ID: <AANLkTiksB7D6XwJRE+0oH26U3yz5h--JwmSYcMX+VrCo@mail.gmail.com>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com> <alpine.DEB.1.10.1012300623070.27193@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1012300623070.27193@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lots of tremendous responses. I appreciate it. I'm going to reply to
the first person who responded here, but this email should cover some
of the questions posed in further responses.

On Thu, Dec 30, 2010 at 00:24, Mikael Abrahamsson <swmike@swm.pp.se> wr=
ote:
> On Thu, 30 Dec 2010, James wrote:
>
>> Can someone point me in the right direction?
>> (a) what causes these errors precisely?
>
> dmesg should give you information if this is SATA errors.

Here are some other logs that may be relevant:

Dec 15 15:40:34 nuova kernel: sd 0:0:0:0: [sda] Unhandled error code
Dec 15 15:40:34 nuova kernel: sd 0:0:0:0: [sda] Result: hostbyte=3D0x00
driverbyte=3D0x06
Dec 15 15:40:34 nuova kernel: sd 0:0:0:0: [sda] CDB: cdb[0]=3D0x28: 28
00 3b e3 53 ea 00 00 48 00
Dec 15 15:40:34 nuova kernel: end_request: I/O error, dev sda, sector 1=
004753898
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262528 on sda4)
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262536 on sda4)
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262544 on sda4)
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262552 on sda4)
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262560 on sda4)
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262568 on sda4)
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262576 on sda4)
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262584 on sda4)
Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
sectors at 974262592 on sda4)

Unfortunately I had not caught those error messages at first
glance...I/O error? Hrmm...doesn't sound good. The issue is repeated
later on.

Dec 29 03:04:01 nuova kernel: sd 1:0:1:0: [sdd] Unhandled error code
Dec 29 03:04:01 nuova kernel: sd 0:0:1:0: [sdb] Unhandled error code
Dec 29 03:04:01 nuova kernel: sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00
driverbyte=3D0x06
Dec 29 03:04:01 nuova kernel: sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x28: 28
00 1b 06 d2 ea 00 00 78 00
Dec 29 03:04:01 nuova kernel: end_request: I/O error, dev sdb, sector 4=
53432042
Dec 29 03:04:01 nuova kernel: sd 1:0:1:0: [sdd] Result: hostbyte=3D0x00
driverbyte=3D0x06
Dec 29 03:04:01 nuova kernel: sd 1:0:1:0: [sdd] CDB: cdb[0]=3D0x28: 28
00 1b 06 d2 62 00 00 88 00
Dec 29 03:04:01 nuova kernel: end_request: I/O error, dev sdd, sector 4=
53431906
Dec 29 03:04:01 nuova kernel: raid5_end_read_request: 13 callbacks supp=
ressed
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940552 on sdd4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940672 on sdb4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940680 on sdb4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940688 on sdb4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940696 on sdb4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940704 on sdb4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940712 on sdb4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940720 on sdb4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940728 on sdb4)
Dec 29 03:04:01 nuova kernel: md/raid:md4: read error corrected (8
sectors at 422940736 on sdb4)

Ouch.

>> (c) are these errors expected in a RAID array that is heavily used?
>
> No.
>
>> (d) what kind of errors should I see regarding "read errors" that
>> *would* indicate an imminent hardware failure?
>
> You should look into the SMART information on the drives using smartc=
tl.

All of the drives indicate that the SMART status is
"passed"...unfortuantely this isn't very verbose. :)

Is there something specific I should be looking at in my SMART status?

I also see hundreds and hundreds of lines in my /var/log/messages that
indicates the following:


Dec 20 06:12:40 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 195 Hardware_ECC_Recovered changed from 47 to 46
Dec 20 07:12:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 68
Dec 20 07:12:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 33 to 32
Dec 20 07:12:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 68
Dec 20 07:12:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 33 to 32
Dec 20 07:42:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 195 Hardware_ECC_Recovered changed from 46 to 45
Dec 20 08:12:39 nuova smartd[22451]: Device: /dev/sdb [SAT], SMART
Usage Attribute: 195 Hardware_ECC_Recovered changed from 42 to 41
Dec 20 08:42:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 195 Hardware_ECC_Recovered changed from 46 to 45
Dec 20 08:42:39 nuova smartd[22451]: Device: /dev/sdc [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 66 to 67
Dec 20 08:42:39 nuova smartd[22451]: Device: /dev/sdc [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 34 to 33
Dec 20 09:42:39 nuova smartd[22451]: Device: /dev/sdb [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 68
Dec 20 09:42:39 nuova smartd[22451]: Device: /dev/sdb [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 33 to 32
Dec 20 10:12:39 nuova smartd[22451]: Device: /dev/sdb [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 68 to 67
Dec 20 10:12:39 nuova smartd[22451]: Device: /dev/sdb [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 32 to 33
Dec 20 10:12:39 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 195 Hardware_ECC_Recovered changed from 45 to 44
Dec 20 11:12:40 nuova smartd[22451]: Device: /dev/sdb [SAT], SMART
Usage Attribute: 195 Hardware_ECC_Recovered changed from 41 to 40
Dec 20 13:42:39 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 195 Hardware_ECC_Recovered changed from 44 to 43
Dec 20 14:42:40 nuova smartd[22451]: Device: /dev/sdb [SAT], SMART
Usage Attribute: 195 Hardware_ECC_Recovered changed from 40 to 39
Dec 20 15:42:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 68 to 67
Dec 20 15:42:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 32 to 33
Dec 20 15:42:40 nuova smartd[22451]: Device: /dev/sdc [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 66
Dec 20 15:42:40 nuova smartd[22451]: Device: /dev/sdc [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 33 to 34
Dec 20 15:42:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 68 to 67
Dec 20 15:42:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 32 to 33
Dec 20 16:12:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 68
Dec 20 16:12:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 33 to 32
Dec 20 16:12:40 nuova smartd[22451]: Device: /dev/sdc [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 66 to 67
Dec 20 16:12:40 nuova smartd[22451]: Device: /dev/sdc [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 34 to 33
Dec 20 16:12:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 68
Dec 20 16:12:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 33 to 32
Dec 20 16:42:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 68 to 67
Dec 20 16:42:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 32 to 33
Dec 20 16:42:39 nuova smartd[22451]: Device: /dev/sdc [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 66
Dec 20 16:42:39 nuova smartd[22451]: Device: /dev/sdc [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 33 to 34
Dec 20 16:42:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 68 to 67
Dec 20 16:42:40 nuova smartd[22451]: Device: /dev/sdd [SAT], SMART
Usage Attribute: 194 Temperature_Celsius changed from 32 to 33
Dec 20 17:12:39 nuova smartd[22451]: Device: /dev/sda [SAT], SMART
Usage Attribute: 190 Airflow_Temperature_Cel changed from 67 to 68

Is it normal for SMART to update the attributes as the drives are
being used? (I've never had SMART installed before, so this is all
very new to me).

-james

> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
