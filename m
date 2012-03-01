From: Milan Broz <mbroz@redhat.com>
Subject: Re: md raid5 fsync deadlock
Date: Thu, 01 Mar 2012 09:46:11 +0100
Message-ID: <4F4F3753.80505@redhat.com>
References: <4F4EB53C.6060901@redhat.com> <20120301125325.2b17e5f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120301125325.2b17e5f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/2012 02:53 AM, NeilBrown wrote:
> On Thu, 01 Mar 2012 00:31:08 +0100 Milan Broz<mbroz@redhat.com>  wrote:

> Are you certain it is a deadlock?  No forward progress at all?

Seems so, it was for several hours in this state without progress.

> What is in md/stripe_cache_size?  Does it change?

> What happens if you double the number in stripe_cache_size?  What if you
> double it again?

stripe_cache_size was 256, I doubled it to 512, now
   stripe_cache_active is 390
   stripe_cache size is 512
and no progress.

With stripe_cache size 1024 it survived few iterations of fio run, now it is
locked up again:
   stripe_cache_active is 921
   stripe_cache size is 1024

Thanks,
Milan
