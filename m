From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: raid6 check/repair
Date: Fri, 30 Nov 2007 19:34:33 +0100
Message-ID: <475057B9.30701@ph.tum.de>
References: <474431BF.30103@ph.tum.de>	<18244.64972.172685.796502@notabene.brown>	<4745B375.4030500@ph.tum.de> <18254.21949.441607.134763@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18254.21949.441607.134763@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

>> The point that I'm trying to make is, that there does exist a specific
>> case, in which recovery is possible, and that implementing recovery for
>> that case will not hurt in any way.
> 
> Assuming that it true (maybe hpa got it wrong) what specific
> conditions would lead to one drive having corrupt data, and would
> correcting it on an occasional 'repair' pass be an appropriate
> response?

The use case for the proposed 'repair' would be occasional,
low-frequency corruption, for which many sources can be imagined:

Any piece of hardware has a certain failure rate, which may depend on
things like age, temperature, stability of operating voltage, cosmic
rays, etc. but also on variations in the production process.  Therefore,
hardware may suffer from infrequent glitches, which are seldom enough,
to be impossible to trace back to a particular piece of equipment.  It
would be nice to recover gracefully from that.

Kernel bugs or just plain administrator mistakes are another thing.

But also the case of power-loss during writing that you have mentioned
could profit from that 'repair':  With heterogeneous hardware, blocks
may be written in unpredictable order, so that in more cases graceful
recovery would be possible with 'repair' compared to just recalculating
parity.

> Does the value justify the cost of extra code complexity?

In the case of protecting data integrity, I'd say 'yes'.

> Everything costs extra.  Code uses bytes of memory, requires
> maintenance, and possibly introduced new bugs.

Of course, you are right.  However, in my other email, I tried to sketch
a piece of code which is very lean as it makes use of functions which I
assume to exist.  (Sorry, I didn't look at the md code, yet, so please
correct me if I'm wrong.)  Therefore I assume the costs in memory,
maintenance and bugs to be rather low.

Kind regards,

Thiemo

