From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mismatch_cnt again
Date: Tue, 17 Nov 2009 00:19:40 -0500
Message-ID: <yq1hbstd8yb.fsf@sermon.lab.mkp.net>
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
	<4AFEE283.9040702@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFEE283.9040702@tmr.com> (Bill Davidsen's message of "Sat, 14
	Nov 2009 12:01:55 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Rabbitson <rabbit+list@rabbit.us>, NeilBrown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Bill" == Bill Davidsen <davidsen@tmr.com> writes:

>> FWIW, databases on raw disk have gone out of fashion.  But it is true
>> that applications that do direct I/O need to avoid updating buffers
>> in flight.
>> 

Bill> May have gone out of fashion in new applications (I'm not sure I
Bill> agree, but as a talking point), 

I don't believe Oracle supports it anymore.  ASM solves this and several
other problems.


Bill> but there are tons of old apps which are not going to be updated
Bill> any time soon, and any number of libraries which mmap stuff and
Bill> effect multiple applications.

We'll just unmap the page while it's being written out.

-- 
Martin K. Petersen	Oracle Linux Engineering
