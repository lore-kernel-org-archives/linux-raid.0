From: Neil Brown <neilb@suse.de>
Subject: Re: AWFUL reshape speed with raid5.
Date: Fri, 1 Aug 2008 11:43:19 +1000
Message-ID: <18578.27191.869553.910780@notabene.brown>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
	<alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>
	<cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com>
	<cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
	<48909578.9020307@tmr.com>
	<cccedfc60807300931g5a05b197j38022a024fa1f0e@mail.gmail.com>
	<alpine.DEB.1.10.0807301306510.1848@p34.internal.lan>
	<cccedfc60807301048t4aef1c1nd9f55e4424b0c057@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Wednesday July 30
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday July 30, jnelson-linux-raid@jamponi.net wrote:
> On Wed, Jul 30, 2008 at 12:08 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > In dstat, the speed is doubled for the total for some reason, divide by 2
> > (if you compare with iostat -x -k 1) you should see the difference.
> 
> Ah, nice catch. It still doesn't change my question.
> Upon further reflection, I believe I know what has caused the
> read/write disparity:
> 
> 1. I've done so much testing with these devices that the contents have
> been zeroed many times.
> 2. I am GUESSING that if the raid recovery code reads from drives A,
> B, and C, builds the appropriate checksum and verifies it, if the
> checksum matches it skips the write. I believe that this is what is
> happening. To confirm, I wrote a few gigs of /dev/urandom to one of
> the devices and re-tested. Indeed, this time around I saw plenty of
> writing. One mystery solved.

I note that while in the original mail in this thread you were talking
about growing an array by adding drives, you are now talking about
growing an array by using more space on each drive.  This change threw
me at first...

You are correct.  When raid5 is repairing parity, it reads everything
and only writes if something is found to be wrong.  This is in-general
fast.  When you grow the --size of a raid5 it repairs the parity on
the newly added space.  If this already has correct parity, nothing
will be written.

> 
> Remaining questions:
> 
> 1. Why does the version of metadata matter so much in a --grow --size operation?

I cannot measure any significant different.  Could you give some
precise details of the tests you run and the results you get ?

> 2. There appear to be bugs when a bitmap is used. Can somebody else confirm?

Confirmed.  If you --grow an array with a bitmap, you will hit
problems as there is no mechanism to grow the bitmap.
What you need to do is to remove the bitmap, do the 'grow', then
re-add the bitmap.
I thought I had arranged that a grow would fail if there was a bitmap
in place, but I guess not.
I'll have a look into this.

Thanks.

NeilBrown



> 3. I'll look into the awful speed thing later as that doesn't seem to
> be an issue.
> 
> -- 
> Jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
