From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: USB-to-SATA and RAID
Date: Thu, 25 Jan 2018 01:36:28 +0100
Message-ID: <20180125003628.GB1756@otheros>
References: <20180123201614.GI23784@otheros>
 <ea8286c7-d5de-610a-8bd0-40481dfa2cd4@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ea8286c7-d5de-610a-8bd0-40481dfa2cd4@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Many thanks for all the quick and helpful responses so far!


On Tue, Jan 23, 2018 at 06:40:14PM -0600, Stan Hoeppner wrote:
> > Could someone elaborate further on this? Does "interacts very
> > badly" mean that there will be potential data loss / data
> > corruption? Or does "very badly" just mean short, temporary
> > performance issues / lags upon a disk failure?
> 
> Potential data loss / data corruption.  Don't use USB.  Use eSATA instead. 
> The list archives of linux-raid and linux-xfs are dotted with USB disk
> horror stories.

Interesting. Do you know what they could be attributed to
technically? Were they usually similar to what Vojtěch had
described, so connectivity issues due to the poor connectors and
thin cables which can often be found with USB? And things then
fell over when for a brief moment connectivity issues occured for
more disks than redundant disks were configured? Or do the extra
latencies with USB create an extended exposure to the write loop
hole in RAID5? Or something else?

Would you guys say that ARM boards with a SATA connector
internally weird to USB (for instance the Ordoid HC2[*]), and then
maybe some SATA Port Multiplier are similarly affected? Or would say
that those are mainly unaffected of the common issues with RAIDs
via SATA over USB?

Regards, Linus

[*]: http://www.hardkernel.com/main/products/prdt_info.php?g_code=G151505170472&tab_idx=2
