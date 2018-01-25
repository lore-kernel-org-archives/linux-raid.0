From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: USB-to-SATA and RAID
Date: Wed, 24 Jan 2018 19:39:13 -0600
Message-ID: <ed53b81c-21a2-4db0-63b5-8b14c78d104b@hardwarefreak.com>
References: <20180123201614.GI23784@otheros>
 <ea8286c7-d5de-610a-8bd0-40481dfa2cd4@hardwarefreak.com>
 <20180125003628.GB1756@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180125003628.GB1756@otheros>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 01/24/2018 06:36 PM, Linus Lüssing wrote:
> Hi,
>
> Many thanks for all the quick and helpful responses so far!
>
>
> On Tue, Jan 23, 2018 at 06:40:14PM -0600, Stan Hoeppner wrote:
>>> Could someone elaborate further on this? Does "interacts very
>>> badly" mean that there will be potential data loss / data
>>> corruption? Or does "very badly" just mean short, temporary
>>> performance issues / lags upon a disk failure?
>> Potential data loss / data corruption.  Don't use USB.  Use eSATA instead.
>> The list archives of linux-raid and linux-xfs are dotted with USB disk
>> horror stories.
> Interesting. Do you know what they could be attributed to
> technically? Were they usually similar to what Vojtěch had
> described, so connectivity issues due to the poor connectors and
> thin cables which can often be found with USB? And things then
> fell over when for a brief moment connectivity issues occured for
> more disks than redundant disks were configured? Or do the extra
> latencies with USB create an extended exposure to the write loop
> hole in RAID5? Or something else?
Here is an example of what you may see with a USB connected drive:

http://forums.debian.net/viewtopic.php?f=10&t=48056

You'll have to read up on the USB protocol to see why devices are 
reset.  As with the user in this post, your USB connected drive may 
function fine for a while, but on occasion you'll hit one of these reset 
conditions.  When that occurs your filesystem may survive, or you may 
suffer corruption, or data loss.  I for one would not rely on storage 
that is reliable only 99% of the time. Murphy's law dictates it will 
fail at the worst possible time.

> Would you guys say that ARM boards with a SATA connector
> internally weird to USB (for instance the Ordoid HC2[*]), and then
> maybe some SATA Port Multiplier are similarly affected? Or would say
> that those are mainly unaffected of the common issues with RAIDs
> via SATA over USB?
>
> Regards, Linus
>
> [*]: http://www.hardkernel.com/main/products/prdt_info.php?g_code=G151505170472&tab_idx=2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

