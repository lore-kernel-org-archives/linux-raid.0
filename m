From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Poor RAID5 performance on new SMP system
Date: Mon, 18 Oct 2004 16:45:00 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410182045.i9IKj5N18178@www.watkins-home.com>
References: <41740E71.4090907@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41740E71.4090907@sauce.co.nz>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have never used AMD MBs, but until now I had plans to buy AMD the next
time I build a system.  Stick with Intel, seems like a safe bet.  The real
thing, not a generic equivalent! :)

Seems like they should have recalled the south bridge chip set.  At least
that would stop new boards from hitting the market.  And the MB companies
that want to keep customers should offer a free replacement.  The lost time
can easily cost more than the board!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Richard Scobie
Sent: Monday, October 18, 2004 2:42 PM
To: linux-raid@vger.kernel.org
Subject: Re: Poor RAID5 performance on new SMP system

Marc Marais wrote:
> I've moved one of the IDE cards to the 64 bit bus and thats improved
things a
> lot. The 2nd card isnt 3.3v capable and won't go into the 64 bit slot
though
> so I'm going to replace it. 
> 
> I noticed using vmstat that the average latency (await) is over 50ms for
the
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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

