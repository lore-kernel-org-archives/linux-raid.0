From: "John Stoffel" <john@stoffel.org>
Subject: Re: Failed during rebuild (raid5)
Date: Fri, 3 May 2013 12:23:24 -0400
Message-ID: <20867.58492.72376.428170@quad.stoffel.home>
References: <51839E4F.7050102@midgaard.us>
	<5183A1C7.5000905@mpstor.com>
	<20130503124023.GB27548@cthulhu.home.robinhill.me.uk>
	<20867.49429.400548.184315@quad.stoffel.home>
	<5183CF09.1080605@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5183CF09.1080605@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Stoffel <john@stoffel.org>, Robin Hill <robin@robinhill.me.uk>, Andreas Boman <aboman@midgaard.us>, linux-raid@vger.kernel.org, Benjamin ESTRABAUD <be@mpstor.com>
List-Id: linux-raid.ids

>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:

Phil> On 05/03/2013 09:52 AM, John Stoffel wrote:
>> 
>> After watching endless threads about RAID5 arrays losing a disk, and
>> then losing a second during the rebuild, I wonder if it would make
>> sense to:
>> 
>> - have MD automatically increase all disk timeouts when doing a
>> rebuild.  The idea being that we are more tolerant of a bad sector
>> when rebuilding?  The idea would be to NOT just evict disks when in
>> potentially bad situations without trying really hard.  

Phil> This would be conterproductive for those users who actually
Phil> follow manufacturer guidelines when selecting drives for their
Phil> arrays.

Well for them, which is drives supporting STEC, etc, you'd skip that
step.  But for those using consumer drives, it might make sense.  And
I didn't say to make this change for all arrays, just for those in a
rebuilding state where losing another disk would be potentially
fatal. 

Phil> Anyways, it's a policy issue that belongs in userspace.  Distros
Phil> can do this today if they want.  There's no lack of scripts in
Phil> this list's archives.

Sure, but I'm saying that MD should push the policy to default to
doing this.  You can turn if off if you like and if you know enough.  

>> - Automatically setup an automatic scrub of the array that happens
>> weekly unless you explicitly turn it off.  This would possibly
>> require changes from the distros, but if it could be made a core
>> part of MD so that all the blocks in the array get read each week,
>> that would help with silent failures.

Phil> I understand some distros already do this.

>> We've got all these compute cycles kicking around that could be used
>> to make things even more reliable, we should be using them in some
>> smart way.

Phil> But the "smart way" varies with the hardware at hand.  There's
Phil> no "one size fits all" solution here.

What's the common thread?  A RAID5 loses a disk.  While rebuilding,
another disk goes south.  Poof!  The entire array is toast until you
go through alot of manual steps to re-create.  All I'm suggesting is
that when in a degraded state, MD automatically becomes more tolerant
of timeouts, errors and tries harder to keep going.  

John

