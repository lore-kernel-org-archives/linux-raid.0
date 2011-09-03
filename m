From: Marc MERLIN <marc@merlins.org>
Subject: Re: Can reading a raid drive trigger all the other drives in that
 set?
Date: Fri, 2 Sep 2011 22:13:13 -0700
Message-ID: <20110903051312.GR30313@merlins.org>
References: <20110628162205.GG20420@merlins.org>
 <20110902012327.GK30313@merlins.org>
 <CAFx4rwTDCm67QpegfxpVjqeRHmCt=a3z1tNQB2zvW7=0AV-aSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFx4rwTDCm67QpegfxpVjqeRHmCt=a3z1tNQB2zvW7=0AV-aSQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 02, 2011 at 02:28:21PM -0700, Doug Dumitru wrote:
> If this is an important, ie. commercial, issue that is costing you
> money, then you might want to pursue this.  If not, then you probably
> need to just disable drive spin-downs or live with it.
 
That was just for home use where I like to save the 60W or so that
having my drives spun down by default, but the up to 30 sec wait for all
of them to spin up one per one feels a bit punitive sometimes :)
I have been "living with it" for a while, but figured that we could do
better.
Thanks for pointing out the plugin solution, I'll look at that in my
copious spare time [tm] :) in addition to the user space solution.
(I already had to write code to watch drive activity and manually spin
them down due to very ill designed firmware:
http://marc.merlins.org/perso/linux/post_2010-08-03_Spinning-Down-WD20EADS-Drives-and-Fixing-Load-Cycle.html
)

> It is also possible that you could appeal to someone with some free
> time (ie, not me) that could do this as a "green" project.  Anyone who
> has worked anywhere near the device-mapper or software-raid layers
> should be able to throw something together.

Understood. If one ever picks up this message and works on it, please
let me know, but I do understand that pretty much everyone already has
their own priorities.

Thanks for the answer,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
