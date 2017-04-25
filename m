From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Tue, 25 Apr 2017 02:16:14 +0200
Message-ID: <20170425001614.GA3936@metamorpher.de>
References: <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de>
 <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 25, 2017 at 01:00:47AM +0200, Patrik Dahlström wrote:
> 6 disk raid xor check: 84 ^ f6 ^ 87 ^ 96 ^ e1 ^ 82 == 0, OK

This should be the 6 disk raid area.

> 5 disk raid xor check: 46 ^ 73 ^ 6d ^ 06 ^ 5e == 0, OK

This should be the 5 disk raid area.

> 6 disk raid xor check: 46 ^ 73 ^ 6d ^ 06 ^ 5e ^ 00 == 0, OK

Still 5 disks... grow did not progess until here, 
and the 6th disk is likely zero because it's new.

> But immediately before that, I can't get the xor sums to line up:
> 0xfaa287ffff: b0 ^ 6d ^ 13 ^ 1b ^ b7 != ae (62 actually), NOK
> This would mean that it's incorrect for both 5 and 6 disk raids.

Not too sure about this point.

If it up and died in mid-grow there might be a chunk that's wrong.

But that's a few kilobytes, not...

> That is a span of ~52 GB where I presumably can't get the checksums
> right. What does all this mean? What am I missing?

...well, it would make sense if a disk got kicked / went missing 
and it progressed the reshape for another ~52GB afterwards. 

If you still had your original md metadata the --examine would clear
that point up but unfortunately...

In a /dev/md that doesn't have that same disk as missing, this would 
result in roughly ~260-320Gs of data that is garbage (because one drive 
was not reshaped but the others were so every nth chunk is wrong).

You might still be able to survive that (if the raid6 <-> raid5 overlap 
zone is larger than that - I didn't do the math, but at a progress of 
17% of your 6T disks you've added about 1T? Might just work out).

So you might have these zones on your RAIDs

6DISK: ?G VALID-DATA : ~320G of GARBAGE : ?G 5DISK-WRONGOFFSET-NONSENSE
5DISK: ?G 6DISK-WRONGOFFSET-NONSENSE : ~260G of GARBAGE : ?G VALID DATA

And you're hoping the VALID DATA areas will overlap. They would if it 
progressed far enough with all disks and not too far with one missing.

Or you just have to identify the questionable drive and kick it out.

You have some experimenteering to do :-|

( 
    Not sure if I'm still making sense at this point. Sorry.
)

Regards
Andreas Klauer
