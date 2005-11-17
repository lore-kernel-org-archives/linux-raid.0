From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [PATCH md 000 of 2] Introduction
Date: Thu, 17 Nov 2005 09:19:46 -0700 (MST)
Message-ID: <Pine.LNX.4.64.0511170916210.4957@filesrv1.baby-dragons.com>
References: <20051115125442.9317.patches@notabene>
 <Pine.LNX.4.64.0511150859360.15915@filesrv1.baby-dragons.com>
 <17276.4385.566615.373265@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17276.4385.566615.373265@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  	Hello Neil ,

On Thu, 17 Nov 2005, Neil Brown wrote:
> On Tuesday November 15, babydr@baby-dragons.com wrote:
>> On Tue, 15 Nov 2005, NeilBrown wrote:
>>> +
>>> +---------------------------
>>> +
>>> +What:  START_ARRAY ioctl for md
>>> +When:  July 2006
>>> +Files: drivers/md/md.c
>>> +Why:   Not reliable by design - can fail when most needed.
>>> +       Alternatives exist
>>> +Who:   NeilBrown <neilb@suse.de>
>>
>>  	Would some please update Documentation/md.txt with the alternates
>>  	that exist to replace START_ARRAY ?  Or for that matter any kernel
>>  	related document that covers the md driver &/or its tools .
>>  		Tia ,  JimL
> Are you just asking "What are the 'Alternatives' that are claimed to
> exist?"?
 	Yes ,  And to have them documented .

> If so, then it is  'mdadm -A'.  I guess I could make that more
> explicit.
 	Hmm ,  Where is mdadm documented as linux-raid tool(set) IN the
 	kernel tree ?  It's not in md.txt ..
# grep mdadm /usr/src/linux/Documentation/md.txt
#
 	Please help me(us) here .

> Or are you asking something else?
 	No ,  You got it right .  Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
