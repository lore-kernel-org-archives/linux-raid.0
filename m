From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Poor RAID5 performance on new SMP system
Date: Tue, 19 Oct 2004 07:41:53 +1300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41740E71.4090907@sauce.co.nz>
References: <20041018015803.M50347@liquid-nexus.net> <41733C14.8020000@sauce.co.nz> <20041018172202.M60005@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041018172202.M60005@liquid-nexus.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marc Marais wrote:
> I've moved one of the IDE cards to the 64 bit bus and thats improved things a
> lot. The 2nd card isnt 3.3v capable and won't go into the 64 bit slot though
> so I'm going to replace it. 
> 
> I noticed using vmstat that the average latency (await) is over 50ms for the
> card on the secondary PCI bus and less than 20ms on the 64 bit bus... Very
> interesting...

Glad it's not going to be a total loss.

I find AMD's behaviour over this bug to be very disappointing - 
motherboards using this broken south bridge can still be purchased today 
and the box does not state "Secondary PCI bus throughput limited to +- 
25MB/s". You will not find this problem mentioned on their website either.

The board I tested is only 9 months old and when I pulled the SCSI card 
and discs and placed them on the 33MHz bus of an equivalent dual Xeon 
board, the throughput went up to +-90MB/s.

I was a big AMD fan prior to this, as the bang for the buck is way 
better, but the time, money and effort wasted left a bad taste.

Regards,

Richard
