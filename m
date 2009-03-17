From: David Greaves <david@dgreaves.com>
Subject: Re: sync_action repair not reading all sectors?
Date: Tue, 17 Mar 2009 10:49:41 +0000
Message-ID: <49BF8045.50004@dgreaves.com>
References: <49BE3786.50809@dgreaves.com>	 <F2C688D6A021E34CB81C0E631EF4C093014C015D@34093-C4-EVS1.exchange.rackspace.com> <87f94c370903160820j6d96ce36t743bfca4a1cfea5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370903160820j6d96ce36t743bfca4a1cfea5e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: David Lethe <david@santools.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

<snip suggestions to replace drive as I am doing that>
Greg Freemyer wrote:
> The question was how to keep the raid-5 as fault tolerant as possible
> during the drive swapout.

I think I'm resigned that that is an on-going feature request :)

Actually I'm more worried that a clearly failing drive is not causing any
problems for a sync_action = repair.

This drive is almost dead and md appears to think it is fine. How come?

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
