From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt again
Date: Fri, 13 Nov 2009 13:15:41 +1100
Message-ID: <19196.49485.82984.444357@notabene.brown>
References: <4AF4C247.6050303@eyal.emu.id.au>
	<4AF4D323.6020108@panix.com>
	<4AF5268D.60900@eyal.emu.id.au>
	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
	<87tyx6tpcb.fsf@frosties.localdomain>
	<4AF58B20.3000409@redhat.com>
	<87iqdlaujb.fsf@frosties.localdomain>
	<20091108160433.GA5338@lazy.lzy>
	<4AF85DCB.3030909@tmr.com>
	<df8de4eb79e2bf13d0e5c2c83cdc7cf1.squirrel@neil.brown.name>
	<4AF9AB6C.4010608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Tuesday November 10
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday November 10, davidsen@tmr.com wrote:
> NeilBrown wrote:
> 
> > You could possibly argue that it is a weakness in the interface to block
> > devices that the block device cannot ask for the buffer to be guaranteed
> > to be stable for the duration of the write, but as there is little real
> > need for that and it would probably be fairly hard to implement both
> > efficiently and generally.
> >
> >   
> The raid code would need it's own copy of the data in a private buffer, 
> or would have to mark the write memory as copy on write. I suspect the 
> 2nd if far more efficient, but I have no idea how hard it would be to 
> implement.

Copy-on-write is not actually possible for md to enforce - it is at
the wrong layer and knows nothing about who owns the page of how or
where it is mapped.
A filesystem can impose copy-on-write, a block device cannot.
I gather from odd comments that I have seen that copy-on-write is
rather expensive.  Marking a thousand contiguous pages copy-on-write
is much faster than copy one thousand pages.  Making a single page
copy-on-write may not be much faster than copying the page.
However I'm not 100% certain of these details.

Maybe if the filesystem could set a flag in the bio saying "this page
will not  change until the write completes", then md could optimise
that case and do copies in other cases...

NeilBrown
