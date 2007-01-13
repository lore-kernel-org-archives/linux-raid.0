From: Nix <nix@esperi.org.uk>
Subject: Re: FailSpare event?
Date: Sat, 13 Jan 2007 23:34:26 +0000
Message-ID: <87odp2pkl9.fsf@hades.wkstn.nix>
References: <eo6cn8$5se$1@sea.gmane.org>
	<17830.47341.560158.521091@notabene.brown>
	<200701121534.17618.earny@net4u.de> <873b6ere4s.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <873b6ere4s.fsf@hades.wkstn.nix> (nix@esperi.org.uk's message of "13 Jan 2007 18:25:19 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: earny@net4u.de
Cc: Neil Brown <neilb@suse.de>, Mike <mikee@mikee.ath.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13 Jan 2007, nix@esperi.org.uk spake thusly:

> On 12 Jan 2007, Ernst Herzberg told this:
>> Then every about 60 sec 4 times
>>
>> event=SpareActive
>> mddev=/dev/md3
>
> I see exactly this on both my RAID-5 arrays, neither of which have any
> spare device --- nor have any active devices transitioned to spare
> (which is what that event is actually supposed to mean).

Hm, the manual says that it means that a spare has transitioned to
active (which seems more likely). Perhaps the comment at line 82 of
Monitor.c is wrong, or I just don't understand what a `reverse
transition' is supposed to be.

-- 
`He accused the FSF of being "something of a hypocrit", which
 shows that he neither understands hypocrisy nor can spell.'
   --- jimmybgood
