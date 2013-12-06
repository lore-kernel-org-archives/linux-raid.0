From: Phill Watkins <phill.watkins@gmail.com>
Subject: Re: Degraded array but drive healthy
Date: Fri, 6 Dec 2013 11:07:50 +0000
Message-ID: <CAONsccXSm6C=um5=EO4yyNEr774ZBoHYgg9iVkM-8RTVRLzwuQ@mail.gmail.com>
References: <CAONsccXLi+1rqZQPsUSfzfuTD3+jWugiH4jAFPKQNLh0aAKSuA@mail.gmail.com>
	<CADNH=7G+JF6TOs6ANoaOtaX-H_mZ_yP3KvqGoUkqGP=LwbsdJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7G+JF6TOs6ANoaOtaX-H_mZ_yP3KvqGoUkqGP=LwbsdJw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thanks for your advice.

I ran a non-destructive badblocks test on the drive last night and the
Multi_Zone_Error_Rate jumped to 9898 and crashed the machine (I can
only assume the terminal was overloaded or something).

I also have an output file full of bad blocks but SMART still shows no =
errors.

    SMART Attributes Data Structure revision number: 16
    Vendor Specific SMART Attributes with Thresholds:
    ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED         RAW_VALUE
     1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail
Always       -       0
     2 Throughput_Performance  0x0026   056   056   000    Old_age
Always       -       11660
     3 Spin_Up_Time            0x0023   089   089   025    Pre-fail
Always       -       3460
     4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       24
     5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail
Always       -       0
     7 Seek_Error_Rate         0x002e   252   252   051    Old_age
Always       -       0
     8 Seek_Time_Performance   0x0024   252   252   015    Old_age
Offline      -       0
     9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       4012
    10 Spin_Retry_Count        0x0032   252   252   051    Old_age
Always       -       0
    11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       37
    12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       24
    191 G-Sense_Error_Rate      0x0022   252   252   000    Old_age
Always       -       0
    192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age
Always       -       0
    194 Temperature_Celsius     0x0002   064   064   000    Old_age
Always       -       31 (Min/Max 21/36)
    195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age
Always       -       0
    196 Reallocated_Event_Count 0x0032   252   252   000    Old_age
Always       -       0
    197 Current_Pending_Sector  0x0032   252   252   000    Old_age
Always       -       0
    198 Offline_Uncorrectable   0x0030   252   252   000    Old_age
Offline      -       0
    199 UDMA_CRC_Error_Count    0x0036   200   200   000    Old_age
Always       -       0
    200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age
Always       -       9898
    223 Load_Retry_Count        0x0032   100   100   000    Old_age
Always       -       37
    225 Load_Cycle_Count        0x0032   100   100   000    Old_age
Always       -       2055

    SMART Error Log Version: 1
    No Errors Logged

Can I assume this is a bad disk and go ahead with an RMA or can the
Multi_Zone_Error_Rate indicate some other issue?

Thanks

P.S. Yes, I used smartctl -t long when I tested the drive.

On 4 December 2013 22:59, Mathias Bur=E9n <mathias.buren@gmail.com> wro=
te:
> On 4 December 2013 22:23, Phill Watkins <phill.watkins@gmail.com> wro=
te:
>>
>> Hi,
>>
>> I have an issue that I can't really pin down.
>>
>> I have two RAID 1 arrays, one for /boot and another for an LVM.
>>
>> Yesterday one of the arrays (the LVM) became degraded after a reboot
>> which included an automated fsck on all filesystems.
>>
>> I've run full SMART tests on both drives and both completed without =
errors:
>> [SNIP]
>>
>> I'd really appreciate some advice.
>>
>> Regards
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Hi,
>
> Full SMART Self-test does that mean smartctl -t long? You could try a
> nondestructive badblocks session on both drives, but it takes a while=
=2E
> http://www.pantz.org/software/badblocks/badblocksusage.html
>
> Regards,
> Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
