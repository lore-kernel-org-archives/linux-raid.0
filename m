From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: how to disable partition search?
Date: Mon, 07 Apr 2008 20:02:38 +0200
Message-ID: <87zls5k0g1.fsf@tac.ki.iif.hu>
References: <87ve39lngy.fsf@tac.ki.iif.hu>
	<20080406103743.GA31334@percy.comedia.it>
	<877ifaoc23.fsf@szonett.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877ifaoc23.fsf@szonett.ki.iif.hu> (Ferenc Wagner's message of
	"Mon, 07 Apr 2008 00:25:56 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ferenc Wagner <wferi@niif.hu> writes:

> Luca Berra <bluca@comedia.it> writes:
>
>> anyway you can rebuild your own kernel disabling it
>> just set PARTITION_ADVANCED, and disable all partition types.
>
> Sounds like a good idea, will try that!

Thanks again, it indeed works!  My boot messages are readable again.
Interestingly, it still says "unknown partition table", but doesn't
try to read it either.  More than good enough for me.

>> you should be aware that doing this will disable partition detection on
>> all drives, so if you have partitioned drives (eg boot drives) you have
>> to run partx in initramfs or it wont be able to access them.
>
> Not in this case.  I'm netbooting and getting / and co. from the SAN
> via multipath and LVM, not a single partition on the whole cluster...

And sure everything just worked with the new kernel.  Wonderful!
-- 
Thanks,
Feri.
