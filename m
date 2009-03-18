From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 18 Mar 2009 15:08:56 +0100
Message-ID: <87wsam53ev.fsf@frosties.localdomain>
References: <87ljr4hsk9.fsf@frosties.localdomain>
	<20090318121825.GL32416@skl-net.de> <49C0EA5F.9070901@vshift.com>
	<20090318123525.GK17185@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318123525.GK17185@skl-net.de> (Andre Noll's message of
	"Wed, 18 Mar 2009 13:35:25 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Ruslan Sivak <russ@vshift.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll <maan@systemlinux.org> writes:

> On 08:34, Ruslan Sivak wrote:
>
>> I would guess the reason is that it doesn't make sense.  As mentioned, if
>> you are going to create a 3 disk raid 6, it's essentially a raid1 over 3
>> disks, at which point you are better off with the raid-1.  I don't think
>> there's a raid controller that would let you set something like this up, I
>> don't see why the softraid should.
>
> Well, Goswin mentioned some pretty good reasons I think.
>
> Andre
> -- 
> The only person who always got his work done by Friday was Robinson Crusoe

Raid6 is the only level that requires such "sanity".

Here is another scenario: Say you have a 2 disk raid1 and now want to
switch to 5 disk raid6. No problem, add 3 new disks, set up 1+2 disk
raid6, pvmove the data (don't you love LVM?), stop the raid1, grow the
raid6 to 5 disks.

It is clear that 1+2 disk raid6 only makes sense as a transitory step
but one that is usefull.

MfG
        Goswin
