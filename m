From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software Raid Cache
Date: Mon, 24 Feb 2003 17:04:59 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15961.46603.166633.265132@notabene.cse.unsw.edu.au>
References: <3E56910F.6050509@lamp-post.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SoulBlazer on Friday February 21
To: SoulBlazer <soul@lamp-post.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 21, soul@lamp-post.net wrote:
> I was wondering if it would be possible to set aside a large (larger) 
> amount of system memory to act as cache for software raid.
> I have a few xeon systems here with 4-8gb of memory in them and based on 
> watching the performance of some mylex raid cards
> jump up when we did a memory upgrade from 64mb -> 128mb I was wondering 
> if the same would occur in linux.
> 
> If this is even something doable (tweakable) Im wondering what the perf 
> gain from allocating say 2 or 4gb just to raid cache would be.
> 
> Comments ?

How do you imagine this extra 'cache' would be used.

Cache on raid cards tends to be battery backed (I believe) and to
operate as a write-behind cache thereby increasing performance.  As
main system memory is not battery backed, you cannot use it as a
write-behind cache.

NeilBrown
