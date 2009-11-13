From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: mismatch_cnt again
Date: Fri, 13 Nov 2009 06:19:31 +0100
Message-ID: <87ocn7xaqk.fsf@frosties.localdomain>
References: <eyal@eyal.emu.id.au>
	<200911121920.nACJKDew011818@wind.enjellic.com>
	<19196.50228.743428.552300@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19196.50228.743428.552300@notabene.brown> (Neil Brown's message
	of "Fri, 13 Nov 2009 13:28:04 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: greg@enjellic.com, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Thursday November 12, greg@enjellic.com wrote:
>> 
>> Neil/Martin what do you think?
>
> I think that if you found out which blocks were different and mapped
> that back through the filesystem, you would find that those blocks are
> not a part of any file, or possibly are part of a file that is
> currently being written.
>
> I guess I need to start logging the error address so people can start
> dealing with facts rather than fears.
>
> NeilBrown

+1

Even if only to debug where the mismatch comes from. Maybe it is the
raid layer or the fs layer or swap. Currently we just can not tell.

MfG
        Goswin
