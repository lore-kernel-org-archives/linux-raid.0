From: Phil Turmel <philip@turmel.org>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 19:24:15 -0500
Message-ID: <4D5C6AAF.1040600@turmel.org>
References: <20110216212751.51a294aa@notabene.brown>	<20110216202939.GA2756@lazy.lzy> <20110217084826.77f4dbf1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217084826.77f4dbf1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 04:48 PM, NeilBrown wrote:
> On Wed, 16 Feb 2011 21:29:39 +0100 Piergiorgio Sartor
>>
>>> Better reporting of inconsistencies.
>>> ------------------------------------
>>>
>>> When a 'check' finds a data inconsistency it would be useful if it
>>> was reported.   That would allow a sysadmin to try to understand the
>>> cause and possibly fix it.
>>
>> Could you, please, consider to add, for RAID-6, the
>> capability to report also which device, potentially,
>> has the problem? Thanks!
> 
> I would rather leave that to user-space.  If I report where the problem is, a
> tool could directly read all the blocks in that stripe and perform any fancy
> calculations you like.  I may even write that tool (but no promises).

Hmmm.  The existing "check" code, if it encounters a read error, will use
available redundancy to recover that data and rewrite it on the spot.

Without a read error, or with multiple redundancy, the calculations to
check consistency are performed and reported.  With all the data "hot", and half
the calculation to pinpoint an inconsistency done, it seems a shame to have
userspace redo it.

Are you adamantly opposed to the kernel doing this?  (For Raid6)  Code talks,
of course, but I'd rather not start if I'm only going to be shot down.

Phil
