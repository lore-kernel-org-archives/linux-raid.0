From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Recreate raid 10 array
Date: Fri, 10 Apr 2009 03:41:45 +0200
Message-ID: <874owx5lpi.fsf@frosties.localdomain>
References: <49DA5CE6.7030902@gmx.net> <87prfpdm8y.fsf@frosties.localdomain>
	<49DD1B87.2050804@tmr.com> <1239227842.18515.8.camel@cichlid.com>
	<49DD21C6.4060200@gmx.net> <1239274037.23944.3.camel@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1239274037.23944.3.camel@cichlid.com> (Andrew Burgess's message
	of "Thu, 09 Apr 2009 03:47:17 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: LCID Fire <lcid-fire@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Burgess <aab@cichlid.com> writes:

> On Thu, 2009-04-09 at 00:14 +0200, LCID Fire wrote:
>
>> > Most fscks can be told to run read-only so they won't write to the
>> > device and also interactive so they ask before writing so you should be
>> > able to avoid recopying. The ext3 journal recovery violates at least one
>> > of these IIRC (or used to) so if it's ext3 find an option to tell it to
>> > ignore the journal.
>
>> Too late. The journal recovery did complain quite a bit and I didn't 
>> know better than to have it fix the things it liked to fix.
>
> Sorry to hear that. Actually our advice should have been to assemble the
> array read-only, then all manner of fs bugs/features could not write to
> it.

But then you couldn't mount it at all since the journal replay needs
to happen in ext3.

> If anyone ever implements the --wild-ass-guess/--recreate mdadm option
> perhaps that should automatically set read-only?

MfG
        Goswin
