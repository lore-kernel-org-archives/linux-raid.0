From: David Brown <david.brown@hesbynett.no>
Subject: Re: Multi-layer raid status
Date: Fri, 02 Feb 2018 12:32:27 +0100
Message-ID: <5A744C4B.7030704@hesbynett.no>
References: <5A708F8E.2040604@hesbynett.no> <87372k2aix.fsf@notabene.neil.brown.name> <5A744054.4060305@hesbynett.no> <5A7448AF.3050108@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A7448AF.3050108@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/18 12:17, Wols Lists wrote:
> On 02/02/18 10:41, David Brown wrote:
>> Using bad block lists and then doing a higher level scrub should
>> certainly work, and is a good general solution as it means you don't
>> need direct interaction between the layers (just the normal top-down
>> processing of layered block devices).  The disadvantage is that there
>> may be quite a delay between the raid1 rebuild and the next full re-read
>> of the entire raid5 array - all you really need is a single read at the
>> higher level to trigger the fixup.
> 
> This would be a perfect use case of my "full parity reads" mode ... at
> the moment, raid just reads sufficient disks to return the requested
> data, but I proposed a mode where it read the full stripe, did the
> parity checks, and either returned a read error (2-disk raid-1, raid-5)
> or corrected the stripe (raid-6) if things didn't add up.
> 

You already do that during a scrub.  You don't want to do it during
normal operations - unless you have a usage pattern with mostly big
reads, you will cripple performance.  A small performance drop is
acceptable if it can be shown to significantly improve reliability - but
making every read a full stripe read will give you random read
performance closer to that of a single disk than a raid array.

> Okay, it would knacker performance a bit, but where you've got a nested
> raid like this, you switch it on, run a read on the filesystem ( tar /
> --no-follow > /dev/null sort of thing), and it would sort out integrity
> all the way down the stack.
> 

That's a scrub.  You do it as a very low priority task on a regular basis.



