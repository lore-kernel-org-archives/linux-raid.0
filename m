From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid over 48 disks
Date: Thu, 20 Dec 2007 20:53:56 -0500
Message-ID: <476B1CB4.2070404@tmr.com>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com> <Pine.LNX.4.64.0712181325480.13538@p34.internal.lan> <476820B0.9010200@ph.tum.de> <Pine.LNX.4.64.0712181523250.7823@p34.internal.lan> <476837F6.7050404@ph.tum.de> <476936DD.40301@tmr.com> <476A9CE4.4010107@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476A9CE4.4010107@ph.tum.de>
Sender: linux-raid-owner@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Norman Elton <normelton@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thiemo Nagel wrote:
> Bill Davidsen wrote:
>>>     16k read    64k write
>>>   chunk
>>>   size    RAID 5    RAID 6    RAID 5    RAID 6
>>>   128k    492    497    268    270
>>>   256k    615    530    288    270
>>>   512k    625    607    230    174
>>>   1024k   650    620    170    75
>>>   
>>
>> What is your stripe cache size?
>
> I didn't fiddle with the default when I did these tests.
>
> Now (with 256k chunk size) I had
>
> # cat stripe_cache_size
> 256
>
> but increasing that to 1024 didn't show a noticeable improvement for 
> reading.  Still around 550MB/s.

You can use blockdev to raise the readahead, either on the drives or the 
array. That may make a difference, I use 4-8MB on the drive, more on the 
array depending on how I use it.
>
> Kind regards,
>
> Thiemo
>


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


