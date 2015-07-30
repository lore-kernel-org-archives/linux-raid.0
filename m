From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 3/3] Safeguard against writing to an active device of
 another node
Date: Thu, 30 Jul 2015 11:16:25 +0800
Message-ID: <55B99709.2050609@suse.com>
References: <1436172732-21021-1-git-send-email-gqjiang@suse.com>	<1436172732-21021-3-git-send-email-gqjiang@suse.com>	<20150729172853.33d44808@noble>	<55B8ADE1.1060708@suse.com> <20150730080247.20f03d23@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150730080247.20f03d23@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
>
> Probably something like that - yes.  Unfortunately your mailer messed
> that up more that usual make it rather difficult to apply.
>
>   
Sorry, it is just for review.
> I was wondering if we could make it a run-time dependency though .. a
> bit like get_cluster_name.  We can still do that later I guess.  I'm
> not really sure what is best at the moment.
>
>   
It could be, I am changing it and run some test, then the new version patch
will be send.

Thanks,
Guoqing
