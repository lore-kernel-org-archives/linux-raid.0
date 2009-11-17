From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mismatch_cnt again
Date: Tue, 17 Nov 2009 00:22:07 -0500
Message-ID: <yq1d43hd8u8.fsf@sermon.lab.mkp.net>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>
	<4AF5268D.60900@eyal.emu.id.au>
	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
	<87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>
	<87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us>
	<20091109185632.GA2723@lazy.lzy>
	<73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>
	<20091109215443.GA4143@lazy.lzy>
	<d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
	<4AF92DBD.5010102@rabbit.us> <yq1tyx2o4td.fsf@sermon.lab.mkp.net>
	<4AFC8EC5.6060400@tmr.com> <yq1my2ql56a.fsf@sermon.lab.mkp.net>
	<87lji92aii.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lji92aii.fsf@frosties.localdomain> (Goswin von Brederlow's
	message of "Sat, 14 Nov 2009 20:04:37 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bill Davidsen <davidsen@tmr.com>, Peter Rabbitson <rabbit+list@rabbit.us>, NeilBrown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Goswin" == Goswin von Brederlow <goswin-v-b@web.de> writes:

>> I agree that making MD RAID1 do a copy would be a quick fix.  But I
>> don't see any reason to encourage what is essentially sloppy behavior
>> at the top of the stack.  And then what if you stack MD/DM devices?
>> Do each layer do a copy?  I think that gets murky pretty quickly.

Goswin> Maybe as a quick debug the raid layer should make the page
Goswin> read-only and then watch what fails to write to it.

That's essentially what the fs-level debug patches do.  The advantage is
that you get a bit more information about the call path when you do it
up there.


Goswin> Maybe a flag somewhere saying if the data is safe from writes or
Goswin> not. Default would be unsafe and md copies. A filesystem that
Goswin> works "right" sets the safe flag as would md after copying. That
Goswin> way anything lower in the stack (like another md) has the flag
Goswin> set.

I actually have a patch kicking around in my guilt stack that implements
such a flag.  Mostly because it appears nobody is interested in fixing
ext2.

-- 
Martin K. Petersen	Oracle Linux Engineering
