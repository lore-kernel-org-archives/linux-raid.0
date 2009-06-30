From: Neil Brown <neilb@suse.de>
Subject: Re: md: Use new topology calls to indicate alignment and I/O sizes
Date: Wed, 1 Jul 2009 09:58:32 +1000
Message-ID: <19018.42664.764760.682918@notabene.brown>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<20090630202432.GG7888@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Tuesday June 30
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jens.axboe@oracle.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Tuesday June 30, snitzer@redhat.com wrote:
> 
> Neil,
> 
> Any chance you could make a formal pull request for this MD topology
> support patch for 2.6.31-rc2?

Yes.. I want to include a couple of other patches in the same batch
and I've been a bit distracted lately (by a cold among other things).
I'll try to get this sorted out today.

> 
> NOTE: all the disk_stack_limits() calls must pass the 3rd 'offset' arg
> in terms of bytes and _not_ sectors.  So all of MD's calls to
> disk_stack_limits() should pass: rdev->data_offset << 9

Noted, thanks.

NeilBrown
