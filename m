From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 23 Jun 2006 10:34:02 +0200
Message-ID: <449BA77A.4000001@idgmail.se>
References: <44960C45.9050407@anu.edu.au>	<17558.10906.59066.196870@cse.unsw.edu.au>	<449B3A80.4070602@tmr.com> <17563.17224.85968.572754@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17563.17224.85968.572754@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> In short, reducing a raid5 to a particular size isn't something that
> really makes sense to me.  Reducing the amount of each device that is
> used does - though I would much more expect people to want to increase
> that size.

Think about the poor people! :-) Those who can't afford to buy a new
disk after a failure but can give up some free space. I actually don't
think that that scenario is /highly unlikely/ to occur?

And also for the sake of symmetry: If growing is allowed- why should not
shrinking be just as valid?

Neil Brown wrote:
> If Paul really has a reason to reduce the array to a particular size
> then fine.  I'm mildly curious, but it's his business and I'm happy
> for mdadm to support it, though indirectly.  But I strongly suspect
> that most people who want to resize their array will be thinking in
> terms of the amount of each device that is used, so that is how mdadm
> works.

I agree with you here- keep the parameters "low level". In that way the
administrator (users use a GUI) have more control over the operation at
hand. (kmdadm anyone? :-))

--
Henrik Holst

