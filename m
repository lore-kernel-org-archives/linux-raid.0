From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - *Slow SSDs likely solved*
Date: Sat, 16 Feb 2013 23:01:13 -0600
Message-ID: <51206419.8020208@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <511361B3.8060204@hardwarefreak.com> <51137C57.7070509@websitemanagers.com.au> <511F0C20.1000005@hardwarefreak.com> <cfefe7a6-a13f-413c-9e3d-e061c68dc01b@email.android.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cfefe7a6-a13f-413c-9e3d-e061c68dc01b@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/16/2013 11:27 AM, Adam Goryachev wrote:
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> On 2/7/2013 4:05 AM, Adam Goryachev wrote:
>>
>>> Storage server:
>> ...
>>> 5 x Intel 520s MLC 480G SATA3
>>> Debian Stable .. *kernel 2.6.32-5-amd64*
>>
>> There was a regression in 2.6.32 kernels that hammered SSD performance.
>> Upgrade to linux-image-3.2.0-0.bpo.3-amd64 and it should fix it.  See:

Correction, make that:  linux-image-3.2.0-0.bpo.4-amd64  (most current)

>> http://www.archivum.info/linux-ide@vger.kernel.org/2010-02/00243/bad-performance-with-SSD-since-kernel-version-2.6.32.html
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642729
>>
>> It was reverted in 2.6.33 upstream, and supposedly reverted in 2.6.32
>> upstream stable.  But apparently, according to Ben Hutchings last
>> comment in the Debian bug report, it hasn't been fixed yet in Debian
>> 2.6.32, and that was over a year ago.
> 
> That sounds like the right solution, would seem to make a massive difference...

2-3x greater throughput per SSD.  Yeah, slight improvement. ;)

> However, apparently there is another bug in kernels newer than 2.6.32 which causes iscsi to fail... When I previously upgraded the kernel to 3.2.x to fix an LVM problem I had caused, I noticed iscsi didn't work, so I reverted to 2.6.32 after I finished fixing the LVM issue.

I don't find any issues WRT iscsi in linux-image-3.2.0-0.bpo.4-amd64
(3.2.35-2~bpo60+1)

> I'll have to watch out for that when I get to it.

That seems a bit nonchalant given you started this thread due to low
RAID performance. ;)  Makes sense though, given that the actual cause of
the user complaints was elsewhere-- in the network.

>> BTW, did you get the LSI card into the server yet, and if so have you
>> run any FIO tests to compare with the previous onboard SATA2 numbers
>> you posted?  Would be interesting to see what performance advantage, if
>> any, it has over the onboard SATA2, and would also allow us to see just how
>> much difference the new kernel makes.
> 
> Well, I'm guessing it won't make much difference given the above bug, but yes, I did install the new LSI card at the same time as the extra ethernet ports....

I assure you it made a difference.  I'm curious how much.  Given all the
testing you did early on I figured you'd want to know this as well.

>> Also, which LSI board did you get, the 9211 or 9307?  You simply said
>> you got the "recommended" one, or something like that.
> 
> The 9307-8i, the one that my supplier couldn't find initially, that you said was the best option because it specifically supported the high IOPS that the SSD's were capable of.

I typo'd previously, it's actually 9207.

Excellent.  If you expand to 8 of these Intel 520s it can't handle the
combined 400K IOPS easily.  One more thing makes running DRBD
continuously possible.

> I'll have to upgrade the kernel, but will need to be careful, I need to make sure the new kernel will work properly for both DRBD and iscsi ....

The only DRBD issue I see related to linux-image-3.2.0-0.bpo.4-amd64
(3.2.35-2~bpo60+1) is false reporting of high disk utilization.  Not a
show stopper:  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=698450

> Another option would be to manually compile my own kernel and just revert that specific patch myself, but I really dislike doing that, I prefer to use the standard packages.....

Yes, it's more difficult and time consuming to support rolled customer
kernels.  In this case it shouldn't be necessary given you're using high
volume COTS hardware and widely used protocols (iscsi).

-- 
Stan

