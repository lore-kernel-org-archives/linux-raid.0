From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 10:36:07 -0700
Message-ID: <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com>
	 <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com>
	 <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net>
	 <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com>
	 <4BCEFB99.9080806@tmr.com> <4BCF163C.6040604@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCF163C.6040604@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Bill Davidsen <davidsen@tmr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 21, 2010 at 8:14 AM, Phillip Susi <psusi@cfl.rr.com> wrote:
<SNIP>
> I've not seen any anecdotal stories, but I have seen plenty of report=
s
> with real data showing a large number of head unloads from the SMART
> data after a relatively short period of use. =C2=A0Personally mine ha=
s a few
> hundred so far and I have not even used it for real storage yet, only
> testing. =C2=A0The specifications say it's good for 300,000 cycles, s=
o do the
> math... getting 5 unloads per minute would lead to probable failure
> after 41 days. =C2=A0Granted that is about worst case, but still some=
thing to
> watch out for. =C2=A0In order to make it the entire 3 year warranty p=
eriod,
> you need to stay under 11.4 unloads per hour. =C2=A0If you have very =
little
> IO activity, or VERY MUCH, then this is entirely possible, but more
> moderate loads in the middle have been observed to cause hundreds of
> unloads per hour.
>
> Given that, and the fact that WD themselves have stated that you shou=
ld
> not use these drives in a raid array, I'd either stay away, or watch =
out
> for this problem and try to take action to avoid and monitor it.

I think I reported this earlier, but here is a WD10EARS drive in a
standard Gentoo Linux desktop machine. The drive has 1661 hours
powered up and 43508 load cycles. That's 26/hour and works out to
about 14 months before it will be out of spec at 300K cycles.

This machine only gets a few hours of use a day but is generally
powered up all the time. I don't know why Linux wakes this drive up
roughly every two minutes, assuming it's Linux and not the drive
itself or something on the motherboard, but it does.

I tried three of these drives in a RAID1 in another machine and they
simply didn't work. Went off line over and over, with big wait times
when they were working. I made no other changes expect changing to a
WD 500GB RAID Edition drive and get almostno load cycle counts at all.

- Mark

gandalf ~ # smartctl -i /dev/sda
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD10EARS-00Y5B1
Serial Number:    WD-WCAV55464493
=46irmware Version: 80.00A80
User Capacity:    1,000,204,886,016 bytes
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Apr 21 10:35:32 2010 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

gandalf ~ #
gandalf ~ # smartctl -A /dev/sda
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   129   128   021    Pre-fail
Always       -       6525
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       21
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   098   098   000    Old_age
Always       -       1661
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       20
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       5
193 Load_Cycle_Count        0x0032   186   186   000    Old_age
Always       -       43508
194 Temperature_Celsius     0x0022   121   116   000    Old_age
Always       -       26
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

gandalf ~ #
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
