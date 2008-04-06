From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: how to disable partition search?
Date: Mon, 07 Apr 2008 00:25:56 +0200
Message-ID: <877ifaoc23.fsf@szonett.ki.iif.hu>
References: <87ve39lngy.fsf@tac.ki.iif.hu>
	<20080406103743.GA31334@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080406103743.GA31334@percy.comedia.it> (Luca Berra's message
	of "Sun, 6 Apr 2008 12:37:43 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, wferi@niif.hu
List-Id: linux-raid.ids

Luca Berra <bluca@comedia.it> writes:

> On Wed, Mar 26, 2008 at 12:43:41PM +0100, Ferenc Wagner wrote:
>
>> I use an FC SAN, which provides multiple pathes to multiple LUNs.
>> These all come up as different sd* devices, exhausting single letter
>> names.  I mean they are a LOT.  Using the md mulitpath driver
>> everything works perfectly, no problems there.  However, during boot,
>> the kernel tries to read the partition table from each device,
>> spitting out hundreds of lines of error messages: most of the devices
>> aren't even readable, and those which are, don't contain a valid
>> partition table.  They never will.  So I'd like to disable partition
>> detection, because these messages overflow the kernel message buffer,
>> depriving syslog of gathering any useful boot messages, and also
>> needlessly lengthening the boot process.  (Of course the noise alone
>> is disturbing enough when one tries to troubleshoot a boot problem.)
>> However, looking at the kernel sources didn't give me any hint.  Is
>> this possible to disable at all?
>
> you could try bugging lkml until it dawns on them that partition
> detection code should belong in userspace by default :)

:) Very well put.  Thanks for strenghtening my belief.

> anyway you can rebuild your own kernel disabling it
> just set PARTITION_ADVANCED, and disable all partition types.

Sounds like a good idea, will try that!  This makes bugging lkml
unnecessary, if not for changing the default...  But that's more a
distribution issue, I think.  And now that we have udev and kpartx,
things will probably drift in this direction.

> you should be aware that doing this will disable partition detection on
> all drives, so if you have partitioned drives (eg boot drives) you have
> to run partx in initramfs or it wont be able to access them.

Not in this case.  I'm netbooting and getting / and co. from the SAN
via multipath and LVM, not a single partition on the whole cluster...
-- 
Thanks for the tip!
Feri.
