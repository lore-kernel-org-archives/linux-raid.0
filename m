From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Stacked array data recovery
Date: Mon, 02 Jul 2012 15:27:38 -0500
Message-ID: <4FF2043A.4060505@hardwarefreak.com>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>   <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>   <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>   <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>  <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>  <4FEA1A4F.9090605@hardwarefreak.com> <1341223955.3407.6.camel@hoferr-desktop.hofer.rummelring>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1341223955.3407.6.camel@hoferr-desktop.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/2/2012 5:12 AM, Ramon Hofer wrote:
> On Die, 2012-06-26 at 15:23 -0500, Stan Hoeppner wrote:
> 
>> Regardless, unless the dd commands hung in some way, they should not
>> show up in top right now.  So it's probably safe to assume they completed.
>>
>> So at this point you can try creating the RAID5 array again.  If the dd
>> command did what we wanted, /dev/sdk should have remapped the bad
>> sector, and you shouldn't get the error kicking that drive.  If you
>> still do, you may need to replace the drive.
> 
> I have successfully run dd for all the four drives.
> 
> But because I couldn't create the raid I ran smartctl again for all of
> them. It seems that sdk has to be replaced. Here are the outputs:

> sdk:
> http://pastebin.com/raw.php?i=cgfq3202

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
...
  5 Reallocated_Sector_Ct   0x0033   133   133   140    Pre-fail  Always   FAILING_NOW 1265
  7 Seek_Error_Rate         0x002e   103   103   000    Old_age   Always       -       15797
196 Reallocated_Event_Count 0x0032   142   142   000    Old_age   Always       -       58
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       14
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       15
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       15

Yes, the drive is toast.  Above are the indicators.  IIRC, your previous smartctl run showed only a count of 3 for Current_Pending_Sector, but no other errors.  Zero'ing the drive with dd has uncovered the true severity of the drive's problems, as another 1000+ bad sectors were identified by the drive and remapped.

So yes, the drive needs to be replaced.

-- 
Stan
