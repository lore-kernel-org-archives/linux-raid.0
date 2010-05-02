From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5
Date: Sun, 02 May 2010 18:51:54 -0400
Message-ID: <4BDE020A.9060602@tmr.com>
References: <s2q6b16fb4c1004182046x5464351m861ccaf9850f33df@mail.gmail.com>	 <j2k4877c76c1004182121w3edcf996x2ee8ee0eca398985@mail.gmail.com>	 <4BCEFE66.6010607@tmr.com> <l2g4877c76c1004211243n6dfa55pfee322db20ba6f08@mail.gmail.com> <4BD1AE0C.2040003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD1AE0C.2040003@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Michael Evans <mjevans1983@gmail.com>, Kaushal Shriyan <kaushalshriyan@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Michael Evans wrote:
>   
>> On Wed, Apr 21, 2010 at 6:32 AM, Bill Davidsen <davidsen@tmr.com> wrote:
>>     
> []
>   
>>> I have some recent experience with this gained the hard way, by looking for
>>> a problem rather than curiousity. My experience with LVM on RAID is that, at
>>> least for RAID-5, write performance sucks. I created two partitions on each
>>> of three drives, and two raid-5 arrays using those partitions. Same block
>>> size, same tuning for stripe-cache, etc. I dropped an ext4 on on array, and
>>> LVM on the other, put ext4 on the LVM drive, and copied 500GB to each. LVM
>>> had a 50% performance penalty, took twice as long. Repeated with four drives
>>> (all I could spare) and found that the speed right on an array was roughly
>>> 3x slower with LVM.
>>>
>>>       
>> This issues sounds very likely to be write barrier related.  Were you
>> using an external journal on a write-barrier honoring device?
>>     
>
> This is most likely due to read-modify-write cycle which is present on
> lvm-on-raid[456] if the number of data drives is not a power of two.
> LVM requires the block size to be a power of two, so if you can't fit
> some number of LVM blocks on whole raid stripe size your write speed
> is expected to be ~3 times worse...
>
>   
Since I tried 3 and 4 drive setups, with several chunk sizes, I would 
hope that no matter how lvm counts data drives (why does it care?) it 
would find a power of two there.
> Even creating partitions on such raid array is difficult.
>
> 'Hwell.
>
> Unfortunately very few people understand this.
>
> As of write barriers, it looks like either they already work
> (in 2.6.33) or will be (in 2.6.34) for whole raid5-lvm stack.
>
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

