From: Chris Murphy <lists@colorremedies.com>
Subject: Re: How do I tell which disk failed?
Date: Tue, 8 Jan 2013 10:36:55 -0700
Message-ID: <8E6A9D9C-F5B6-4686-81CA-98721329BEEA@colorremedies.com>
References: <1357610701.16366.13.camel@corn.betterworld.us> <50EBAC5D.8080000@hardwarefreak.com> <1357628351.16366.86.camel@corn.betterworld.us> <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com> <1357631387.16366.131.camel@corn.betterworld.us> <F5C2E9CA-635E-4FA5-9C20-EB0F6AE94838@colorremedies.com> <1357637558.16366.154.camel@corn.betterworld.us>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357637558.16366.154.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 8, 2013, at 2:32 AM, Ross Boylan <ross@biostat.ucsf.edu> wrote:

> On Tue, 2013-01-08 at 01:48 -0700, Chris Murphy wrote:
>>> 
>> 
>> Not good. The current value is 56, the worst is 24, and the threshold is 0. These are high values. 
> Do you mean 56, 24, and 0 are high values?  Or the raw values are high?

0 is the point at which the drive will change its health from passing to failing. It's gotten as low as 24. So I'd say it's pre-failing, it just isn't telling you that literally. As raw values go up, the current value goes down. The closer current and threshold are, the worse the health of the drive for that particular attribute. It's actually a bit more complicated than that, there's lots of discussion of this on the smatmontools site.

> Is the raw value wrapping around?

No idea.

> # date; smartctl -a /dev/sda
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>  1 Raw_Read_Error_Rate     0x000f   075   063   044    Pre-fail  Always       -       38010669
>  3 Spin_Up_Time            0x0003   099   099   000    Pre-fail  Always       -       0
>  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       101
>  5 Reallocated_Sector_Ct   0x0033   099   099   036    Pre-fail  Always       -       31
>  7 Seek_Error_Rate         0x000f   078   060   030    Pre-fail  Always       -       65563711282
>  9 Power_On_Hours          0x0032   061   061   000    Old_age   Always       -       34776
> 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
> 12 Power_Cycle_Count       0x0032   100   037   020    Old_age   Always       -       102
> 184 Unknown_Attribute       0x0032   100   100   099    Old_age   Always       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
> 188 Unknown_Attribute       0x0032   100   088   000    Old_age   Always       -       335
> 189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
> 190 Airflow_Temperature_Cel 0x0022   066   057   045    Old_age   Always       -       34 (Lifetime Min/Max 34/36)
> 194 Temperature_Celsius     0x0022   034   043   000    Old_age   Always       -       34 (0 18 0 0)
> 195 Hardware_ECC_Recovered  0x001a   044   024   000    Old_age   Always       -       38010669
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0

So there have been reallocated sectors, so some of them are bad. And since they tend to be located in groups, it probably explains why you had a slow initial rebuild that then sped up. Again, if it's under warranty, get rid of it. If it's not, well, I'd probably still get rid of it or use it for something inconsequential, after using hdparm to secure erase it (or use dd to write zeros, which is OK for HDDs, not OK for SSDs).


> Fortunately, I've already got new disks in the machine.  The transition
> has proved challenging.
> 
> I was more or less ready to go, but I wanted to do some experiments with
> the alignment of partitions and other parameters.  Any suggestions would
> be great.

You must've missed the other email I sent about alignment. The reds are not aligned. And you're using completely whacky partition sizes between sda and sd[bc] for reasons I don't understand.

http://www.spinics.net/lists/raid/msg41506.html


> P.S. Here are the results for sdb, which has also been generating
> chatter in the logs.

What do you mean by chatter in the logs? I don't see anything wrong here, but as something like 35% of drive failures occur without SMART ever indicating a single problem, who knows.


Chris Murphy

