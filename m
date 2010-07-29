From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Pending sectors in valid array - how to proceed?
Date: Wed, 28 Jul 2010 19:50:49 -0700
Message-ID: <AANLkTinDLyQPdRwx6e=Qx71rnTOAS093Az0EEr_v5+NL@mail.gmail.com>
References: <4C506CF5.2080307@xunil.at>
	<4C5079C4.2050308@seoss.co.uk>
	<4C5092C4.6050708@gmx.net>
	<20100729031100.69f583d7@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100729031100.69f583d7@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 28, 2010 at 2:11 PM, Roman Mamedov <roman@rm.pp.ru> wrote:
> On Wed, 28 Jul 2010 22:27:48 +0200
> Stefan *St0fF* Huebner <st0ff@gmx.net> wrote:
>
>> >> =A0 5 Reallocated_Sector_Ct =A0 0x0033 =A0 100 =A0 100 =A0 036 =A0=
 =A0Pre-fail =A0Always
>> >> =A0 =A0 =A0 - =A0 =A0 =A0 0
>> >> 195 Hardware_ECC_Recovered =A00x001a =A0 058 =A0 039 =A0 000 =A0 =
=A0Old_age =A0 Always
>> >> =A0 =A0 =A0 - =A0 =A0 =A0 146754005
>> >> 197 Current_Pending_Sector =A00x0012 =A0 100 =A0 100 =A0 000 =A0 =
=A0Old_age =A0 Always
>> >> =A0 =A0 =A0 - =A0 =A0 =A0 13
>> >> 198 Offline_Uncorrectable =A0 0x0010 =A0 100 =A0 100 =A0 000 =A0 =
=A0Old_age
>> >> Offline =A0 =A0 =A0- =A0 =A0 =A0 13
>> >>
>> >> (relevant lines as far as I understand ...)
>> >>
>> > Do you have any high-fly writes? =A0Are there lots of
>> > Hardware_ECC_Recovered on all the drives? =A0Is vibration likely t=
o be an
>> > issue? =A0What's the drive/chassis?
>> Hardware ECC recovered means how many times the internal error
>> correction of the drive succeeded. =A0Indeed this may indicate vibra=
tion
>> or other external sources of errors.
>
> That drive is most likely a Seagate, and if so, there's nothing to wo=
rry
> about. Literally every Seagate drive will have a high value in
> Hardware_ECC_Recovered, it's just a peculiarity of their SMART. Other=
 vendors'
> drives recover read errors using ECC too, but don't report that into =
the SMART
> metric.
>

I am waiting for this drive to get to the point that Seagate will accep=
t an RMA:

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   089   076   006    Pre-fail
Always       -       173224741
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       69
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       2002
  7 Seek_Error_Rate         0x000f   046   036   030    Pre-fail
Always       -       42786857552386
  9 Power_On_Hours          0x0032   082   082   000    Old_age
Always       -       16170
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       5
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       69
184 Unknown_Attribute       0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   012   012   000    Old_age
Always       -       88
188 Unknown_Attribute       0x0032   100   090   000    Old_age
Always       -       112
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   064   057   045    Old_age
Always       -       36 (Lifetime Min/Max 33/43)
194 Temperature_Celsius     0x0022   036   043   000    Old_age
Always       -       36 (0 10 0 0)
195 Hardware_ECC_Recovered  0x001a   031   020   000    Old_age
Always       -       173224741
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0


It is a desktop drive and is used for half of several  RAID1 arrays,
but so far it hasn't been kicked out of any arrays. I have run a check
several times in the last few days.  I had expected it to show a
failing state when the reallocated sector count reached 2000, but it
hasn't.

The Seek Error rate is an order of magnitude higher than an identical
drive that is the other half of those RAID1 arrays:

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   108   091   006    Pre-fail
Always       -       31895651
  3 Spin_Up_Time            0x0003   094   093   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       55
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   056   051   030    Pre-fail
Always       -       3741314243502
  9 Power_On_Hours          0x0032   082   082   000    Old_age
Always       -       16221
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       2
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       55
184 Unknown_Attribute       0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   049   049   000    Old_age
Always       -       51
188 Unknown_Attribute       0x0032   100   098   000    Old_age
Always       -       2
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   059   051   045    Old_age
Always       -       41 (Lifetime Min/Max 39/49)
194 Temperature_Celsius     0x0022   040   049   000    Old_age
Always       -       40 (0 9 0 0)
195 Hardware_ECC_Recovered  0x001a   025   015   000    Old_age
Always       -       31895651
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   192   000    Old_age
Always       -       15



Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
