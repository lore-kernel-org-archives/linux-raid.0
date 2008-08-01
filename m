From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: AWFUL reshape speed with raid5.
Date: Fri, 1 Aug 2008 08:23:37 -0500
Message-ID: <cccedfc60808010623n6eb3c92bl613840a95e839050@mail.gmail.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
	 <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>
	 <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com>
	 <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
	 <48909578.9020307@tmr.com>
	 <cccedfc60807300931g5a05b197j38022a024fa1f0e@mail.gmail.com>
	 <alpine.DEB.1.10.0807301306510.1848@p34.internal.lan>
	 <cccedfc60807301048t4aef1c1nd9f55e4424b0c057@mail.gmail.com>
	 <18578.27191.869553.910780@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18578.27191.869553.910780@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 31, 2008 at 8:43 PM, Neil Brown <neilb@suse.de> wrote:
> I note that while in the original mail in this thread you were talking
> about growing an array by adding drives, you are now talking about
> growing an array by using more space on each drive.  This change threw
> me at first...

True. Mea Culpa.

>> Remaining questions:
>>
>> 1. Why does the version of metadata matter so much in a --grow --size operation?
>
> I cannot measure any significant different.  Could you give some
> precise details of the tests you run and the results you get ?

I'll try to throw some stuff together soon.

>> 2. There appear to be bugs when a bitmap is used. Can somebody else confirm?
>
> Confirmed.  If you --grow an array with a bitmap, you will hit
> problems as there is no mechanism to grow the bitmap.
> What you need to do is to remove the bitmap, do the 'grow', then
> re-add the bitmap.
> I thought I had arranged that a grow would fail if there was a bitmap
> in place, but I guess not.
> I'll have a look into this.

A small suggestion: to avoid trepidation, perhaps a small note like
"you may re-add the bitmap while the array is still
rebuilding/growing/whatever" would help to avoid some worry.

There are two other solutions:
Have the underlying code grow the bitmap (probably hard), or have it
automatically remove+re-add the bitmap.


-- 
Jon
