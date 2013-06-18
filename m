From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 5: low sequential write performance?
Date: Tue, 18 Jun 2013 00:52:10 -0500
Message-ID: <51BFF58A.60602@hardwarefreak.com>
References: <51BCF46B.40704@fatooh.org> <20926.11718.556180.928129@tree.ty.sabi.co.uk> <51BEAF12.10909@fatooh.org> <51BF1BAC.9020701@hardwarefreak.com> <51BF43E6.4000900@fatooh.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51BF43E6.4000900@fatooh.org>
Sender: linux-raid-owner@vger.kernel.org
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/17/2013 12:14 PM, Corey Hickey wrote:
> On 2013-06-17 07:22, Stan Hoeppner wrote:
>> On 6/17/2013 1:39 AM, Corey Hickey wrote:
>>
>>> 32768 seems to be the maximum for the stripe cache. I'm quite happy to
>>> spend 32 MB for this. 256 KB seems quite low, especially since it's only
>>> half the default chunk size.
>>
>> FULL STOP.  Your stripe cache is consuming *384MB* of RAM, not 32MB.
>> Check your actual memory consumption.  The value plugged into
>> stripe_cache_size is not a byte value.  The value specifies the number
>> of data elements in the stripe cache array.  Each element is #disks*4KB
>> in size.  The formula for calculating memory consumed by the stripe
>> cache is:
>>
>> (num_of_disks * 4KB) * stripe_cache_size
>>
>> In your case this would be
>>
>> (3 * 4KB) * 32768 = 384MB
> 
> I'm actually seeing a bit more memory difference: 401-402 MB when going
> from 256 to to 32768, on a mostly idle system, so maybe there's
> something else coming into play.

384MB = 402,653,184 bytes

> Still your formula does make more sense.  Apparently the idea of the
> value being KB is a common misconception, possibly perpetuated by this:
> 
> https://raid.wiki.kernel.org/index.php/Performance
> ---
> # Set stripe-cache_size for RAID5.
> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
> echo 16384 > /sys/block/md3/md/stripe_cache_size
> ---

Note that kernel wikis are not official documentation.  They don't
receive the same review as kernel docs.  Pretty much anyone can edit
them.  So the odds of incomplete or misinformation are higher.  And of
course always be skeptical of performance claims.  A much better source
of stripe_cache_size information is this linux-raid thread from March of
this year:  http://www.spinics.net/lists/raid/msg42370.html

> Is 256 really a reasonable default? Given what I've been seeing, it
> appears that 256 is either unreasonably low or I have something else wrong.

Neither.  You simply haven't digested the information given you, nor
considered that many/most folks have more than 3 drives in their md
array, some considerably more drives.  Revisit the memory consumption
equation, found in md(4):

memory_consumed = system_page_size * nr_disks * stripe_cache_size

The current default, 256.  On i386/x86-64 platforms with default 4KB
page size, this consumes 1MB memory per drive.  A 12 drive arrays eats
12MB.  Increase the default to 1024 and you now eat 4MB/drive.  A
default kernel managing a 12 drive md/RAID6 array now eats 48MB just to
manage the array, 96MB for a 24 drive RAID6.  This memory consumption is
unreasonable for a default kernel.

Defaults do not exist to work optimally with your setup.  They exist to
work reasonably well with all possible setups.

-- 
Stan

