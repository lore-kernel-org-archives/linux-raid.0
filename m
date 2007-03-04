From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: mismatch_cnt questions
Date: Mon, 05 Mar 2007 08:21:43 +1100
Message-ID: <45EB3867.8050907@eyal.emu.id.au>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com> <17898.45673.573800.56474@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17898.45673.573800.56474@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday March 4, pernegger@gmail.com wrote:
>>I have a mismatch_cnt of 384 on a 2-way mirror.
[trim]
>>3) Is the "repair" sync action safe to use on the above kernel? Any
>>other methods / additional steps for fixing this?
> 
> "repair" is safe, though it may not be effective.
> "repair" for raid1 was did not work until Jan 26th this year.
> Before then it was identical in effect to 'check'.

How is "repair" safe but not effective? When it finds a mismatch, how does
it know which part is correct and which should be fixed (which copy of
raid1, or which block in raid5)?

When a disk fails we know what to rewrite, but when we discover a mismatch
we do not have this knowledge. It may corrupt the good copy of a raid1.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
