From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Feature request: ability to exchange drive without failing the
 old 	one
Date: Tue, 13 Oct 2009 16:38:12 -0400
Message-ID: <4AD4E534.2010102@tmr.com>
References: <bb145bd20910121740n208e4c71v30520a7ea8b57d21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20910121740n208e4c71v30520a7ea8b57d21@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Christian Pernegger wrote:
> Hi list!
>
> Sometimes I want to exchange a drive in an array even if it hasn't
> actually failed, e. g.
> - in preperation for a grow operation: exchange-resync-exchange-resync-...-grow
> - when removing old drives as part of regular maintenance
> - ...
>
> Currently one has to fail an active drive to trigger a resync to the
> replacement (assuming it was added as a spare beforehand) and thus
> suffer the loss of fault tolerance and performance until the sync is
> complete.
>
> Suggestion: allow adding drives as an explicit replacement for an
> active one. The active drive would then be copied to the new one in
> the background, effectively replacing the component device with a
> mirror. Bonus points if the resulting setup is a valid mode of
> operation and not just a temporary hack. I suppose one could see the
> feature as a special case of the reshaping that's all the rage now :)
>   

I think what you want is a subset of the problem many of us face, moving 
a member of an array to a larger partition on a (much) larger drive. 
That migration, followed by a grow, is getting more appealing, as 
various drive drop to "prize in a cereal box" pricing. And as data 
grows, backup to something other than disk is getting pretty 
impractical, resulting in unit upgrades to save space, time, power, etc, 
etc.

I agree with the need, I have several ugly methods of doing this which 
boil down to replacing a member with a raid-1 of the member and the new 
drive. I have done it several ways, including the "I can't fit another 
drive in the box" solution, using nbd and write mostly. Uglier than a 
hedgehog's ass, but it worked... eventually.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

