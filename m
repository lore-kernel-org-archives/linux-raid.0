From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 01 Apr 2009 20:07:53 +0200
Message-ID: <87prfwb62u.fsf@frosties.localdomain>
References: <87ljr4hsk9.fsf@frosties.localdomain>
	<20090318121825.GL32416@skl-net.de> <49D39169.2050705@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D39169.2050705@zytor.com> (H. Peter Anvin's message of "Wed,
	01 Apr 2009 09:08:09 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andre Noll <maan@systemlinux.org>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"H. Peter Anvin" <hpa@zytor.com> writes:

> Andre Noll wrote:
>> 
>>> So back to my original question: Why does the kernel require 4 disks
>>> for a raid6 instead of allowing 3?
>> 
>> Dunno. Maybe Dan, Neil or HPA can tell the reason for imposing this
>> limitation.
>> 
>
> It's very simple: it avoids an ugly corner case in the RAID-6
> computation code.  Rather than inserting special code (and verifying it,
> etc.) to deal with the 3-disk RAID-6 degenerate case, it was easier to
> just not permit it.
>
> 	-hpa

Could you point me at the file/line where the corner case is?

MfG
        Goswin
