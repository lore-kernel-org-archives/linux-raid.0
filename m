From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster !!
Date: Fri, 29 Jan 2010 12:58:08 +0100
Message-ID: <87y6jh6s33.fsf@frosties.localdomain>
References: <4B5F6C73.30707@texsoft.it>
	<20100127074138.GA9607@maude.comedia.it>
	<20100129214852.00e565c4@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129214852.00e565c4@notabene> (Neil Brown's message of "Fri,
	29 Jan 2010 21:48:52 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Wed, 27 Jan 2010 08:41:38 +0100
> Luca Berra <bluca@comedia.it> wrote:
>
>> On Tue, Jan 26, 2010 at 11:28:03PM +0100, Giovanni Tessore wrote:
>> > Is this some kind of bug?  
>> No
>
>
> I'm not sure I agree.
> If a device is generating lots of read errors, we really should do something
> proactive about that.
> If there is a hot spare, then building onto that while keeping the original
> active (yes, still on the todo list) would be a good thing to do.
>
> v1.x metadata allows the number of corrected errors to be recorded across
> restarts so a real long-term value can be used as a trigger.
>
> So there certainly are useful improvements that could be made here.
>
> NeilBrown

Someone mentioned there already is an error count. Maybe throw a warning
message to mdadm every 1,2,4,8,16,32,... errors?

Locally I would see the read errors in the syslog/kernel.log and start
saving for a new drive. So I'm already warned. But for remote systems a
mail from mdadm would be nice.

MfG
        Goswin
