From: David Brown <david.brown@hesbynett.no>
Subject: Re: Triple parity and beyond
Date: Wed, 20 Nov 2013 11:44:39 +0100
Message-ID: <528C9297.9030801@hesbynett.no>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <20131119181237.GA3666@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131119181237.GA3666@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Andrea Mazzoleni <amadvance@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
List-Id: linux-raid.ids

On 19/11/13 19:12, Piergiorgio Sartor wrote:
> On Mon, Nov 18, 2013 at 11:08:59PM +0100, Andrea Mazzoleni wrote:

<snip for brevity>

> 
> Hi Andrea,
> 
> great job, this was exactly what I was looking for.
> 
> Do you know if there is a "fast" way not to correct
> errors, but to find them?
> 
> In RAID-6 (as per raid6check) there is an easy way
> to verify where an HDD has incorrect data.
> 

I think the way to do that is just to generate the parity blocks from
the data blocks, and compare them to the existing parity blocks.

> I suspect, for each 2 parity block it should be
> possible to find 1 error (and if this is true, then
> quad parity is more attractive than triple one).
> 
> Furthermore, my second (of first) target would
> be something like: http://www.symform.com/blog/tag/raid-96/
> 
> Which uses 32 parities (out of 96 "disks").

I believe Andrea's matrix is extensible as long as you have no more than
257 disks in total.  A mere 32 parities should not be a problem :-)

mvh.,

David


> 
> Keep going!!!
> 
> bye,
> 
> pg
> 
>>
>> Ciao,
>> Andrea
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

