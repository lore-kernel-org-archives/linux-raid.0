From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mismatch_cnt again
Date: Fri, 13 Nov 2009 12:12:45 -0500
Message-ID: <yq1my2ql56a.fsf@sermon.lab.mkp.net>
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
	<4AFC8EC5.6060400@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFC8EC5.6060400@tmr.com> (Bill Davidsen's message of "Thu, 12
	Nov 2009 17:40:05 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Rabbitson <rabbit+list@rabbit.us>, NeilBrown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Bill" == Bill Davidsen <davidsen@tmr.com> writes:

>> FWIW, XFS and btrfs both use the page writeback bit correctly and
>> never change a page while it is undergoing I/O.
>> 
>> 
Bill> That's necessary but not sufficient. To be done correctly it must
Bill> be protected by md as well. This is because arrays are used
Bill> without a filesystem by some applications, such as swap and
Bill> database, to name the most common cases. 

I agree that making MD RAID1 do a copy would be a quick fix.  But I
don't see any reason to encourage what is essentially sloppy behavior at
the top of the stack.  And then what if you stack MD/DM devices?  Do
each layer do a copy?  I think that gets murky pretty quickly.

I'd much rather fix the cases where the top layers are broken.  And as I
said there are several people working on this spurred by my work on the
data integrity extensions.

FWIW, databases on raw disk have gone out of fashion.  But it is true
that applications that do direct I/O need to avoid updating buffers in
flight.

-- 
Martin K. Petersen	Oracle Linux Engineering
