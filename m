From: Mark Smith <nanog@fa1c52f96c54f7450e1ffb215f29991e.nosense.org>
Subject: Re: Interesting RAID checking observations - I'm getting it too
Date: Tue, 5 Sep 2006 06:53:53 +0930
Message-ID: <20060905065353.981e10e9.nanog@fa1c52f96c54f7450e1ffb215f29991e.nosense.org>
References: <20060830192410.332db788.nanog@fa1c52f96c54f7450e1ffb215f29991e.nosense.org>
	<44FC578D.5020704@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FC578D.5020704@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bill,

On Mon, 04 Sep 2006 12:42:53 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> 
> 
> 
> Mark Smith wrote:
> 
> >Just a note, I've noticed this problem too. I run a RAID1 check once
> >every 24 hours, and while developing the script to do it, noticed that
> >the machine became virtually unusable - mouse was jumpy, typing lagged.
> >
> >I run this check every morning at 4.00am so I'm usually asleep and
> >don't notice it, so it hasn't been a big bother to me.
> >  
> >
> Interesting, but do you run other stuff at that time? Several 
> distributions run various things in the middle of the night which really 
> bog the machine.
> 

Pretty sure not. daily cron run at 12.00am, I run a daily smart short
test at 2.00am, and then this check at 4.00 am. I'll switch it off
tonight just to confirm that, by looking at the same sar data.

I think I read on the list that Neil discovered something that he
thinks might be causing it, I figured I just might be able to provide
some data to help confirm that.

Regards,
Mark.

-- 

        "Sheep are slow and tasty, and therefore must remain constantly
         alert."
                                   - Bruce Schneier, "Beyond Fear"
