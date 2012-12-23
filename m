From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Disk speed comparison
Date: Sun, 23 Dec 2012 16:04:13 -0600
Message-ID: <50D77FDD.2050203@hardwarefreak.com>
References: <2944870.0.1356240579079.JavaMail.root@zimbra>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2944870.0.1356240579079.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/22/2012 11:29 PM, Roy Sigurd Karlsbakk wrote:
>>> I have an array with 6 2TB drives plus a spare. While this works
>>> well, I can from the munin graphs at
>>> http://munin.karlsbakk.net/munin/karlsbakk.net/smilla.karlsbakk.net/index.html
>>> that the WD2001FASS drives (sd[bcfg]) perform some 30% better than
>>> the Hitachi HDS723020BLA642 drives (sd[eh]). The drives are on a
>>> mixed set of controllers, so this shouldn't be relevant. Since they
>>> all are specified to spin on 7200RPM, I find it wierd that the
>>> performance difference shown by the Munin graph is so big.
>>
>> You've provided zero information about the controllers or the
>> configuration of the drives. If the SATA ASIC to which the Black
>> drives
>> are connected is AHCI and the other is not, then NCQ may account for
>> the
>> difference in performance. Or, both may currently be AHCI, but
>> possibly
>> the Hitachi drives perform better with NCQ disabled. This would not be
>> rare. If you laid partitions on the Hitachi drives and misaligned
>> them,
>> this could easily cause a 30% deficit. Etc, etc.
>>
>> I doubt there is a 30% overall performance difference between these
>> two
>> drive models. The Black models are "enthusiast" class drives, and do
>> have some additional performance features, but not that I'd think
>> would
>> yield a 30% advantage.
>>
>> You need to dig deeper into the details.
> 
> no partitions on this setup, just plain drives. what munin tells me is those WD drives are rather faster than the hitachis. As noted, all drives are on a mixed controller setup, the hitachis and wd drives share controllers for some. the only known common factor for the slow and fast drives are their label.

I just looked at your Munin graphs more closely.  Your interpretation of
30% difference in performance doesn't seem to be accurate.  All 6 drives
have nearly identical daily and weekly avg IOs and throughput.  The avg
latency of the Hitachi drives is a few milliseconds higher, but this
doesn't seem to be negatively affecting IOPS or throughput.

How are you determining your claimed 30% performance deficit?  I don't
see it.

-- 
Stan

