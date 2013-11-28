From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: =?UTF-8?B?562U5aSN77yabWQgcmFpZDUgcGVyZm9ybWFjZSA2eCBTU0QgUkE=?=
 =?UTF-8?B?SUQ1?=
Date: Thu, 28 Nov 2013 00:24:45 -0600
Message-ID: <5296E1AD.1040005@hardwarefreak.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com>	<20131126061458.GM8803@dastard>	<36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>	<5296C98D.8000302@hardwarefreak.com> <20131128104625.54a5fc94@natsu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131128104625.54a5fc94@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: lilofile <lilofile@aliyun.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/27/2013 10:46 PM, Roman Mamedov wrote:
> On Wed, 27 Nov 2013 22:41:49 -0600
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>>> when the stripe_cache_size is set 4096. 
> ...
>> 2.  A 4KB stripe cache is too small for 6 SSDs, try 8KB
> 
> The stripe cache size setting is specified not in KB, but in pages per disk,
> so a value of 4096 on x86 systems means 4096*4096*6 = 96 MB of cache for the
> whole array.

Thanks Roman for correcting me on that which I know well.  Typing a
trailing "KB" so often hard wires the brain and fingers I guess.  My KBs
were intended to be Ks.

http://www.spinics.net/lists/raid/msg42370.html
On 04/03/13 23:20, Stan Hoeppner wrote:
...
> Formula:  stripe_cache_size * 4096 bytes * drive_count = RAM usage.

To expound on the importance of this, with a handful of SSDs and a value
of 8K, throughput tends to plateau, and then slowly decreases as
stripe_cache_size is increased.  The upper bound of stripe_cache_size
gains has not yet been established because the write thread peaks a core
with only a few SSDs.  Multiple write threads and a larger quantity of
SSDs, or much faster SSDs, are needed to explore whether values of
16K-32K provide a meaningful increase in throughput, and whether this is
worth the RAM consumed.  For instance, with 12 SSDs and
stripe_cache_size of 32768:

(((32768*4096)*12)/1048576)/1000 = 1.5 GB of RAM is consumed

When Shaohua Li completes his threading patch series it may be possible
to explore this more thoroughly.

-- 
Stan

