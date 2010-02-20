From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Maybe crazy idea for reshaping: Instant/On-Demand reshaping
Date: Sat, 20 Feb 2010 11:39:29 +0100
Message-ID: <87mxz46vj2.fsf@frosties.localdomain>
References: <87zl34xyqt.fsf@frosties.localdomain>
	<20100220194020.5d1689e6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100220194020.5d1689e6@notabene.brown> (Neil Brown's message of
	"Sat, 20 Feb 2010 19:40:20 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Sat, 20 Feb 2010 06:27:54 +0100
> Goswin von Brederlow <goswin-v-b@web.de> wrote:
>> So what do you think? Is this lack of cafein speaking?
>
> I think your cost-benefit trade-off is way off balance on the cost side.
>
> This sort of complexity really belongs in a filesystem, not in a a block
> device.
>
> NeilBrown

So you are saying I should be using zfs instead of ext3+raid5. :)

When I read up on zfs last year it could not do any reshaping at
all. You could only add new pools but not reshape an existing one.

MfG
        Goswin
