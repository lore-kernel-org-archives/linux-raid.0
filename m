From: Neil Brown <neilb@suse.de>
Subject: Re: Maybe crazy idea for reshaping: Instant/On-Demand reshaping
Date: Sun, 21 Feb 2010 13:21:27 +1100
Message-ID: <20100221132127.6e49afd3@notabene.brown>
References: <87zl34xyqt.fsf@frosties.localdomain>
	<20100220194020.5d1689e6@notabene.brown>
	<87mxz46vj2.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mxz46vj2.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 20 Feb 2010 11:39:29 +0100
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> Neil Brown <neilb@suse.de> writes:
> 
> > On Sat, 20 Feb 2010 06:27:54 +0100
> > Goswin von Brederlow <goswin-v-b@web.de> wrote:
> >> So what do you think? Is this lack of cafein speaking?
> >
> > I think your cost-benefit trade-off is way off balance on the cost side.
> >
> > This sort of complexity really belongs in a filesystem, not in a a block
> > device.
> >
> > NeilBrown
> 
> So you are saying I should be using zfs instead of ext3+raid5. :)

No, I'm saying that you should fund me for a year or two so I can stop
worrying about bug fixing and md features, and can finish writing the
filesystem that I have been working on for over a decade.  It will,
naturally, be able to to everything including cure the common cold.

NeilBrown


> 
> When I read up on zfs last year it could not do any reshaping at
> all. You could only add new pools but not reshape an existing one.
> 
> MfG
>         Goswin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

