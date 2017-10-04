From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 20:01:41 +0100
Message-ID: <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
 <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com>
 <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>, Curt <lightspd@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/17 19:44, Joe Landman wrote:
> Generally speaking 3 failed drives on a RAID6 is a dead RAID6.  You may 
> get lucky, in that this may have been simply a timeout error (I've seen 
> these on consumer grade drives), or an internal operation on the drive 
> taking longer than normal, and been booted.  In which case, you'll get 
> scary warning messages, but might get your data back.
> 
> Under no circumstances do anything to change RAID metadata right now 
> (grow, shrink, etc.).  Start with basic assembly.  If you can do that, 
> you are in good shape.  If you can't, recovery is unlikely, even with 
> heroic intervention.

No - Curt needs to stop the grow before anything else will work, I 
think. Fortunately, seeing as it's hung at 0% this shouldn't mess about 
with the data at all.

And you NEED to ddrescue that fifth drive. At which point basic assembly 
should hopefully work fine.

(Note that the grow quite likely failed because the fifth drive errored 
... Oh - and are they raid drives? What are they? You don't have a 
timeout mismatch?)

Cheers,
Wol
