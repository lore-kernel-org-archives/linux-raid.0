From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Fri, 26 Mar 2010 14:16:33 -0700
Message-ID: <5bdc1c8b1003261416xdc883a4qdba1cdf049cca437@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BAD18A5.1080905@kieser.ca>
	 <5bdc1c8b1003261359i2f6f1bdai3261aec30bb663bf@mail.gmail.com>
	 <4BAD20A2.20606@kieser.ca>
	 <5bdc1c8b1003261406m2ae66154u55a70aada56a91c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003261406m2ae66154u55a70aada56a91c1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 2:06 PM, Mark Knecht <markknecht@gmail.com> wro=
te:
> On Fri, Mar 26, 2010 at 2:01 PM, Peter Kieser <peter@kieser.ca> wrote=
:
>> On 3/26/2010 1:59 PM, Mark Knecht wrote:
>>>
>>> On Fri, Mar 26, 2010 at 1:27 PM, Peter Kieser<peter@kieser.ca> =C2=A0=
wrote:
>>> <SNIP>
>>>
>>>>
>>>> <SNIP>
>>>>
>>>
>>> This seems to be a windows program? I don't see a Linux version in
>>> Gentoo portage.
>>>
>>> I could run Windows once to set it if the settings are then
>>> maintained, or do you have a Linux solution?
>>>
>>> - Mark
>>>
>>
>> It's a proprietary DOS application written by WDC that changes the s=
ettings
>> on the hard drives firmware. The changes are permanent. You can boot=
 off a
>> USB key or floppy with DOS on it to run the application.
>>
>> -Peter
>
> OK, so possibly FreeDOS will work?
>
> Thanks,
> Mark
>
Here's some data from a WD10EARS. How do I read the LCC_COUNT?


SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   129   128   021    Pre-fail
Always       -       6525
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       19
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       1053
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       18
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       5
193 Load_Cycle_Count        0x0032   191   191   000    Old_age
Always       -       27557
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


Is it currently at 191 with a fail level of 27557?

This drive is in a desktop machine  - non-RAID - that's pretty much
always turned on and is maybe 4-6 weeks old at this point.

Thanks,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
