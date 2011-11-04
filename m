From: Alex <mysqlstudent@gmail.com>
Subject: Re: Impending failure?
Date: Fri, 4 Nov 2011 11:31:48 -0400
Message-ID: <CAB1R3si1BObUpb7iwcS0D2EGd-_Spw4nuBLPxnPBf9he+zuHzA@mail.gmail.com>
References: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
	<alpine.DEB.2.00.1111041529150.19721@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1111041529150.19721@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

>> Can you point me to instructions on the best way to replace a disk?
>
> First run "repair" on the array, hopefully it'll notice the unreadable
> blocks and re-write them.
>
> echo repair >> /sys/block/md0/md/sync_action
>
> Also make sure your OS does regular scrubs of the raid, usually this is done
> by monthly runs of checkarray, this is an example from Ubuntu:

Great, thanks. I recalled something like that, but couldn't remember exactly.

The system passed the above rebuild test on both arrays, but I'm
obviously still concerned about the disk. Here are the relevant
smartctl lines:

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   108   089   006    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0003   094   094   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       29
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   083   060   030    Pre-fail
Always       -       209739855
  9 Power_On_Hours          0x0032   074   074   000    Old_age
Always       -       22816
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       37
187 Reported_Uncorrect      0x0032   095   095   000    Old_age
Always       -       5
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   075   064   045    Old_age
Always       -       25 (Min/Max 23/32)
194 Temperature_Celsius     0x0022   025   040   000    Old_age
Always       -       25 (0 18 0 0)
195 Hardware_ECC_Recovered  0x001a   057   045   000    Old_age
Always       -       51009302
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       2
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       2
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age
Offline      -       0
202 Data_Address_Mark_Errs  0x0032   100   253   000    Old_age
Always       -       0

Pending_sector and uncorrectable are both greater than zero. Is this
drive on its way to failure?

Can someone point me to the proper mdadm commands to set the drive
faulty then rebuild it after installing the new one?

Thanks again,
Alex
