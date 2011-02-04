From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 04 Feb 2011 15:05:41 -0600
Message-ID: <4D4C6A25.5070604@hardwarefreak.com>
References: <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com> <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com> <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <4D470F96.40409@cfl.rr.com> <4D471A41.1090706@hardwarefreak.com> <4D4730C0.8080900@cfl.rr.com> <20110201092007.GA7860@cthulhu.home.robinhill.me.uk> <4D4C2352.9000407@cfl.rr.com> <20110204162212.GA21779@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204162212.GA21779@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin Hill put forth on 2/4/2011 10:22 AM:
> On Fri Feb 04, 2011 at 11:03:30AM -0500, Phillip Susi wrote:
> 
>> FYI, you should get in the habit of using your mail client's reply to
>> all function.  I did not see this until now because you did not send me
>> a copy.
>>
> I'll make an exception in this case, but I generally reply to messages
> on mailing lists to the list only, and I have no plans to change this.
> 
>> On 2/1/2011 4:20 AM, Robin Hill wrote:
>>> No, it's RAID 10 or RAID 1+0. RAID 0+1 would be 2 mirrored pairs of
>>> 5-disk RAID 0 arrays, in which case you could only lose 5 disks if
>>
>> In English we read from left to right and top to bottom, so 0+1 means
>> stripe on top of mirror.
>>
> The vast majority of online sources would disagree with you.  See:
>     http://en.wikipedia.org/wiki/Nested_RAID_levels
>     http://www.aput.net/~jheiss/raid10/
>     http://decipherinfosys.wordpress.com/2008/01/15/difference-between-raid-01-vs-raid-10/
>     http://www.raid.com/04_01_0_1.html
>     http://www.pcguide.com/ref/hdd/perf/raid/levels/multLevel01-c.html
>     http://www.adrc.com/raid-01.html
> 
> The order it's written is the order of creation.  RAID0+1 =  RAID 0,
> then RAID 1 (mirrored stripes) and RAID1+0 = RAID 1, then RAID 0
> (striped mirrors).

LSI is the undisputed king of HBA RAID, with all major server OEMs rebadging LSI
cards and/or using their storage processor chips on the mobo, including Dell,
HP, IBM, Intel, Sun, etc.  Note the diagram at the bottom of this PDF showing
the layout of RAID 10:

http://www.lsi.com/DistributionSystem/AssetDocument/SCG_LSI_SAS_6Gbps_IR_PB_092909.pdf

It clearly shows a stripe over two mirrors.

-- 
Stan
