From: Konstantin Olchanski <olchansk@sam.triumf.ca>
Subject: SMART, was Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 16:15:13 -0700
Message-ID: <20050622231513.GC23624@sam.triumf.ca>
References: <5d96567b05061804477325d743@mail.gmail.com> <200506221316.33178.hjm@tacgi.com> <20050622223833.60b3eba1.pegasus@nerv.eu.org> <200506221433.00321.hjm@tacgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200506221433.00321.hjm@tacgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <hjm@tacgi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 22, 2005 at 02:33:00PM -0700, Harry Mangalam wrote:
> The SMART data ... would tell you considerably more info:
> an example from my home system:
> 1062 $ smartctl -a /dev/hda ...

But does anybody know what all these SMART parameters *mean* ?!?

What is this "Raw_Read_Error_Rate"?
What is this "Seek_Error_Rate"?

AFAIK, only a handful of parameters ("temperature", "reallocated sectors",
and "start stop count") seem to measure something. All the other
stuff appears to be complete gibberish.

Then for the SMART "status", it is completely useless- I had SMART
complain about perfectly good disks ("this disk will fail soon!!!"- a few
120GB WDs that sometimes stop seeking, probably through overheating)
and I had completely unusable disks (i.e. develops about 10 unreadable
sectors per day) that SMART was perfectly happy with.

K.O.


> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always       
> -       0
>   3 Spin_Up_Time            0x0007   099   095   021    Pre-fail  Always       
> -       4141
>   4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always       
> -       122
>   5 Reallocated_Sector_Ct   0x0033   199   199   140    Pre-fail  Always       
> -       2
>   7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail  Always       
> -       0
>   9 Power_On_Hours          0x0032   075   075   000    Old_age   Always       
> -       18940
>  10 Spin_Retry_Count        0x0013   100   100   051    Pre-fail  Always       
> -       0
>  11 Calibration_Retry_Count 0x0013   100   100   051    Pre-fail  Always       
> -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       
> -       120
> 196 Reallocated_Event_Count 0x0032   198   198   000    Old_age   Always       
> -       2
> 197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       
> -       0
> 198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always       
> -       0
> 199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always       
> -       0
> 200 Multi_Zone_Error_Rate   0x0009   200   200   051    Pre-fail  Offline      
> -       0
> 
> SMART Error Log Version: 1
> No Errors Logged
> 
> 
> On Wednesday 22 June 2005 1:38 pm, Jure Pecar wrote:
> > On Wed, 22 Jun 2005 13:16:33 -0700
> >
> > Harry Mangalam <hjm@tacgi.com> wrote:
> > > Perhaps something like the CDDB, where a you can run an applet on a
> > > cronjob  that will upload your disk's SMART data cache to a remote DB on
> > > a regular  basis, so the millions of disks out there can be profiled. 
> > > Hmmm - sounds  like a good undergrad project. Did someone say Summer of
> > > Code? (http://code.google.com/summerofcode.html)
> >
> > Actually if you look at the storagereview.com, they already have a crude
> > form of this online under "reliability survey". You have to login, then you
> > can enter disk model that you have expirience with and what were those
> > expiriences. There's quite some info already available ...
> 
> -- 
> Cheers, Harry
> Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
>             <<plain text preferred>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
