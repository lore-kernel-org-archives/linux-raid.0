From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 03 Apr 2013 13:35:11 -0500
Message-ID: <515C765F.50500@hardwarefreak.com>
References: <loom.20130403T122905-373@post.gmane.org> <515C2C3C.3020400@hardwarefreak.com> <loom.20130403T171527-93@post.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130403T171527-93@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Landmann <sfrazt@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/3/2013 10:31 AM, Peter Landmann wrote:
> Stan Hoeppner <stan <at> hardwarefreak.com> writes:
> 
>>
>> On 4/3/2013 6:00 AM, Peter Landmann wrote:
>>
>> You didn't mention your stripe_cache_size value.  It'll make a lot of
>> difference.  Make sure it's at least 4096.  The default is 256.
> 
> You are very right.
> I increased it to 4096 - 32768 and the performance increased much.

Be careful here.  Increasing stripe_cache_size increases memory
consumption of md dramatically.  Formula:  stripe_cache_size * 4096
bytes * drive_count = RAM usage.  For a 6 drive array that's

stripe_cache_size	RAM consumed
 4096			 96MB
 8192			192MB
16384			384MB
32768			768MB

Thus you want to select a value that gives you the best combination of
performance and lowest memory usage, unless you're not concerned about RAM.

> Also i played a bit with deadline parameters and it helped also to increase 
> performance.
...
> With Raid 5 and 6 SSDs i got 33936 IOPS (fio settings as before) which is not 
> far away from theoretical 40000 (i know from former tests that the performance 
> could be increased for some more jobs).

Always test with parallel threads.  If you don't you're not getting a
realistic picture of what md/RAID and the hardware are capable of.

> For your info: With Raid 6 and 6 SSDs i got 32526 IOPS which is also a very good 
> result.
> 
> So i conclude that there is no (big) problem with scalability at this hw level, 
> right?

Yes.  What this demonstrates is that one Thuban core at 2.8-3.3GHz can
apparently execute the md/RAID5/6 write threads faster than these 6
X25-M G2 SSDs can sink the writes.  If your CPU was a 1.6GHz Atom and/or
these were newer SATAIII Sandforce based SSDs, you'd peak a CPU core
long before the SSDs run out of headroom.

> FYI: The scheduler makes the difference. If you alternate writes and reades in 
> small steps (R W R R W R W W R ..) then the performce decreases heavily. If you 
> group read and write operations (20xW  20xR 20xW ..)then the performance will be 
> better. Tested it without raid and a patched fio (and noop scheduler). But 
> deadline scheduler can reach the same i learned.

The scheduler can play a difference, but with SSDs noop usually gives
the best results.  With some SATA/drive controller combos deadline may
be better.  CFQ is rarely, if ever, good for performance.

> Thx for your informations and hints

You bet.

-- 
Stan


