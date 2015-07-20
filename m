From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Mon, 20 Jul 2015 10:11:01 -0400
Message-ID: <21933.373.338911.954794@quad.stoffel.home>
References: <20150710040847.GA1408097@devbig257.prn2.facebook.com>
	<20150710143656.4ee7e647@noble>
	<20150715004455.GA1024035@devbig257.prn2.facebook.com>
	<20150715121234.22803890@noble>
	<20150715031615.GA1292235@devbig257.prn2.facebook.com>
	<20150715140641.3c61cf78@noble>
	<20150715194927.GA3502691@devbig257.prn2.facebook.com>
	<20150716091653.7b970b32@noble>
	<20150716000739.GA4041321@devbig257.prn2.facebook.com>
	<20150716112217.3e2e685f@noble>
	<20150716041305.GA283306@devbig257.prn2.facebook.com>
	<20150716160711.08c37fc1@noble>
	<21927.51382.8600.700720@quad.stoffel.home>
	<20150720100345.63302007@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150720100345.63302007@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: John Stoffel <john@stoffel.org>, Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:

NeilBrown> On Thu, 16 Jul 2015 11:07:34 -0400 "John Stoffel" <john@stoffel.org>
NeilBrown> wrote:

>> 
>> So.... how will wrapping of sequence numbers be handled in the cache
>> metadata on disk?  They can't grow for ever...

NeilBrown> Can't they?

NeilBrown> A 64bit number incremented every millisecond can grow for half a
NeilBrown> billion years.  As far as I'm concerned, that is forever.

LOL... that is true.  But I'm trying to just think about edge cases
and point out some possible pitfalls in case of corruption or errors.  

NeilBrown> But even if we used 32bit numbers, it is very easy to
NeilBrown> handle looping providing you have few than half of the
NeilBrown> numbers in use at any time.  So as long as we don't have
NeilBrown> more than 2 billion active transactions in the log at once,
NeilBrown> there is no problem.  The kernel does some internal time
NeilBrown> keeping using "jiffies" which, on 32bit systems, cycle
NeilBrown> about every fortnight.  A small amount of care is enough
NeilBrown> that this doesn't cause problem.

All I wanted to make sure, was that this was thought of and handled.
I like the idea of randomly picking a STARTING number, so that we
hopefully exercise all the corner cases properly early on in the process.

John

