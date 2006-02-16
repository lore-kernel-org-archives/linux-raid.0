From: Andrew Nelson <freeandy@gmail.com>
Subject: Re: will mdadm work with a raid created using raidtools
Date: Thu, 16 Feb 2006 12:23:54 -0600
Message-ID: <dt2fvr$sea$1@sea.gmane.org>
References: <43F37BFB.4030908@gmail.com> <17395.45134.227188.527148@cse.unsw.edu.au> <dt24uh$fv8$1@sea.gmane.org> <20060216171413.GG8762@intoxicatedmind.net> <dt2csr$gac$1@sea.gmane.org> <20060216174727.GH8762@intoxicatedmind.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060216174727.GH8762@intoxicatedmind.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Frank Blendinger wrote:
> On Thu, Feb 16, 2006 at 11:31:06AM -0600, Andrew Nelson wrote:
> 
>>>It's probably not your fault - blame /dev/hde! This sounds like a bad
>>>error on the disk - you should really get a new one, and try to copy
>>>/dev/hde to the new disk (with dd_rescue for example). This _might_ save
>>>the data.
>>>
>>>Then you can try to create the array with the new disk and hope that
>>>it will work.
>>
>>
>>I thought the whole idea of a raid 1 was that if one drive went bad I could just
>>plug a new drive in and the raid would rebuild without problems.
> 
> 
> That is certainly right. I just wanted to tell you, that your /dev/hde
> probably has a serious hardware error, and that you should replace it!
> 
> Of course you can just throw it out, put in a new drive, rebuild the
> array with your other drive and the new one, and then resync. This
> should work just fine.
> 
> I guess my first answer was quite confusing, sorry. It's absolutely not
> necessary to copy the old hde with dd_rescue.
> 
> 
> Greetings,
> Frank

Is it possible to assemble the array with just /dev/hdg?  I swear I saw an
option somewhere that allowed just such a thing but now I can't find it anywhere.

//andy



