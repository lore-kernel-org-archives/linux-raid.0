From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: mismatch_cnt again
Date: Tue, 10 Nov 2009 10:09:17 +0100
Message-ID: <4AF92DBD.5010102@rabbit.us>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>    <4AF5268D.60900@eyal.emu.id.au>    <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>    <87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>    <87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us>    <20091109185632.GA2723@lazy.lzy>    <73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>    <20091109215443.GA4143@lazy.lzy> <d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Tue, November 10, 2009 8:54 am, Piergiorgio Sartor wrote:
> <snip>
> 
> check/repair is primarily about reading every block on every device,
> and being ready to cope with read errors by overwriting with the
> correct data.  This is known as scrubbing I believe.
> I would normally just 'repair' every month or so.  If there are
> discrepancies I would like them reported and fixed.  I they happen
> often on a non-swap partition, I would like to knoe about it, otherwise
> I would rather they were just fixed.

Bingo - and according to the list archive many of us are getting mismatches
without swap anywhere near the raid in question. The current situation is
more akin to "Ok folks get in the plane, we're deploying in 2 hours, and
btw your chute is not going to open and there is nothing you can do about
it" How is that for a threat model :)

Please someone step in and add *some* sort of reporting about which
particular blocks are screwed, so a user can figure out which data is(about
to) be lost.
