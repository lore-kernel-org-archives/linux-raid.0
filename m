From: Nix <nix@esperi.org.uk>
Subject: Re: FailSpare event?
Date: Mon, 15 Jan 2007 19:59:43 +0000
Message-ID: <87d55gdpsg.fsf@hades.wkstn.nix>
References: <eo6cn8$5se$1@sea.gmane.org>
	<17830.47341.560158.521091@notabene.brown>
	<200701121534.17618.earny@net4u.de> <873b6ere4s.fsf@hades.wkstn.nix>
	<87k5zqpkfb.fsf@hades.wkstn.nix> <45ABA3E4.3050800@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ABA3E4.3050800@tmr.com> (Bill Davidsen's message of "Mon, 15 Jan 2007 10:55:16 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: earny@net4u.de, Neil Brown <neilb@suse.de>, Mike <mikee@mikee.ath.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15 Jan 2007, Bill Davidsen told this:
> Nix wrote:
>>     Number   Major   Minor   RaidDevice State
>>        0       8        6        0      active sync   /dev/sda6
>>        1       8       22        1      active sync   /dev/sdb6
>>        3      22        5        2      active sync   /dev/hdc5
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       23        0      active sync   /dev/sdb7
>>        1       8        7        1      active sync   /dev/sda7
>>        3       3        5        2      active sync   /dev/hda5
>>
>> 0, 1, and *3*. Where has number 2 gone? (And how does `Number' differ
>> from `RaidDevice'? Why have both?)
>>
>>
> Did you ever move the data to these drives from another? I think this
> is what you see when you migrate by adding a drive as a spare, then
> mark an existing drive as failed, so the data is rebuilt on the new
> drive. Was there ever a device 2?

Nope. These arrays were created in one lump and never had a spare.

Plenty of pvmoves have happened on them, but that's *inside* the
arrays, of course...

-- 
`He accused the FSF of being "something of a hypocrit", which
 shows that he neither understands hypocrisy nor can spell.'
   --- jimmybgood
