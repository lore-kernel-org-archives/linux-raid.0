From: Neil Brown <neilb@suse.de>
Subject: RE: experiences with raid5: stripe_queue patches
Date: Tue, 16 Oct 2007 12:04:30 +1000
Message-ID: <18196.7214.82291.81090@notabene.brown>
References: <200710151703.10404.bs@q-leap.de>
	<BAY125-W2D0CD53AC925A85655321A59C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?gb2312?B?xe3Pr7q6?= <pengxihan@hotmail.com>
Cc: Bernd Schubert <bs@q-leap.de>, linux-raid@vger.kernel.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Tuesday October 16, pengxihan@hotmail.com wrote:
> In my opinion, one
> of ways to increase raid5 performance may be to change STRIPE_SIZE to
> to a bigger value. It is now equal to PAGE_SIZE. But we can't just
> change it simply, some other codes must be modified. I havn't tried,:).
> Maybe Neil can give us some advices!

I really don't think increase STRIPE_SIZE would have much effect.  You
might save a bit of CPU (though it might cost you too) but it should
change the order of requests, so it wouldn't affect disk io much.

I really think this is a scheduling problem.  We need to make sure to
send the requests in the right order without delaying things
needlessly, and avoid reads when ever possible.

NeilBrown
