From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and
 internal bitmap
Date: Thu, 18 Oct 2007 23:45:14 -0400
Message-ID: <4718284A.1040400@tmr.com>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>	<4716769E.5030508@tmr.com>	<170fa0d20710171421l4ff62ebdwdef307e71a2ad30d@mail.gmail.com>	<471754D8.2060909@tmr.com> <18200.6501.186871.539817@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18200.6501.186871.539817@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday October 18, davidsen@tmr.com wrote:
>   
>> Unless there's a substantial benefit from using the 1.0 format, you 
>> might want to go with something which works. 
>>     
>
> I am every grateful to the many people who do not just find work
> arounds, but report problems and persist until they get fixed.
>
> Obviously everyone should choose the path that suits them best, but
> I'd rather we didn't discourage people who are working to get a bug
> fixed. 
>   

Giving them a way to get working and copying you directly seems to be a 
reasonable compromise between ignoring the problem and leaving the 
original poster to think software raid is neither reliable nor supported.

I have never seen any guidance on when 1.0 or 1.2 format is better than 
1.1, perhaps that can go on the documentation queue.
>>                                               I would suggest using 
>> --bitmap-chunk, but the man page claims it doesn't apply to internal 
>> bitmaps. It also claims the bitmap size is chosen automatically to best 
>> use available space, but "doesn't work" seems an exception to "best 
>> use." ;-)
>>     
>
> In this case, it does work, and it is best use.  It just appears that
> the 'available space' is not truly available - read error.
>   

It's not always clear without dmesg if read error is hardware :-( I 
certainly assumed it was config or software in nature.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

