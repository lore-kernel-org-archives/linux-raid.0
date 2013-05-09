From: Sam Bingner <sam@bingner.com>
Subject: Re: Reshape Shrink Hung Again
Date: Thu, 9 May 2013 06:58:08 +0000
Message-ID: <47109EB7-F38D-43A1-874B-23ED05537D92@bingner.com>
References: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com>
	<20130422072414.3e30882c@notabene.brown>
	<7A4C666A-D95E-41AB-96B2-5E75097D8BBB@bingner.com>
	<20130506152926.067d3459@notabene.brown>
	<F83D995D-967D-4D89-9CE9-46A0305290C6@bingner.com>,<20130509161601.5804059f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130509161601.5804059f@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On May 8, 2013, at 8:16 PM, "NeilBrown" <neilb@suse.de> wrote:

> 
> The backup.md file really should not have been empty.
> Assuming you are sure it was the right file something must have gone wrong.
> Not overly surprising as it is hard to test that particular stage of reshape:
> an interruption to the reshape very late in a shrink could get messy.
> 
> I've made a note to try testing it when I next spend some time on mdadm.
> 
> Thanks,
> NeilBrown
> 

That makes sense then, both times that I had this problem it was empty and there was nothing that could have caused it to have a problem.  I'll play with a couple things and see if I can find where the issue was also.

Thank you...
Sam

