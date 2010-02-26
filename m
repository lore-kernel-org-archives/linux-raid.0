From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Fri, 26 Feb 2010 15:15:30 -0500
Message-ID: <4B882BE2.7060005@tmr.com>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at> <4B855B8C.8080802@xunil.at> <4B862F2C.5030302@texsoft.it> <4B86A943.3040804@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B86A943.3040804@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson wrote:
> On 25/02/2010 08:05, Giovanni Tessore wrote:
> [...]
>> I see this is the 4th time in a month that poeple reports problem on 
>> raid5 due to the read errors during reconstruction; it looks like the 
>> 'corrected read errors' policy is quite a real concern.
>
> If you mean md's policy of reconstructing from the other discs and 
> rewriting when there's a read error from one disc of an array, rather 
> than immediately kicking the disc that had a read error, I think 
> you're wrong - I think md is saving lots of users from hitting 
> problems, by keeping their arrays up and running, and giving their 
> discs a chance to remap bad sectors, instead of forcing the user to do 
> full-disc reconstructions more often which will make them more likely 
> to hit read errors during recovery.
>
> I do think we urgently need the hot reconstruction/recovery feature, 
> so failing drives can be recovered to fresh drives with two sources of 
> data, i.e. both the failing drive and the remaining drives in the 
> array, giving us two chances of recovering every sector.

Ideally, there would be a way to avoid kicking any failing drive, or 
even trying to rewrite the unreadable sector. Some md utility which 
would clone a drive using logic similar to this:
 - start with array assembled but not started
 - read a sector from the source drive
   reconstruct t if source fails
   report errors and keep going
 - write any recovered sector to the destination
 - optionally read it back to be sure it worked, rewrite and note errors
   to be useful it must flush to the platter and reread. Yes, it will be 
slow.
 
Don't try to be smart, try to make a usable copy of a drive!

I think in case a sector can't be recovered a fixed pattern should be 
written to the destination, for ease of identification if nothing else.

I think being able to specify MBR or a partition would be useful, that 
would let critical things be saved faster and with less work. This also 
open up possibilities for migration of several kinds.

This really should be a command in mdadm! Why? Because it is vital that 
changes on how mdadm does things are tracked in this tool. Because when 
you are down to trying this you don't want to be looking for matching 
versions, etc.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

