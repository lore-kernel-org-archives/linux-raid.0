From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: Time to deprecate old RAID formats?
Date: Wed, 24 Oct 2007 11:18:29 -0400
Message-ID: <170fa0d20710240818x42a4c611of5780d30ccb07b39@mail.gmail.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org> <471E7DC6.7050206@tmr.com>
	 <18207.20482.272516.461264@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18207.20482.272516.461264@stoffel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/24/07, John Stoffel <john@stoffel.org> wrote:
> >>>>> "Bill" == Bill Davidsen <davidsen@tmr.com> writes:
>
> Bill> John Stoffel wrote:
> >> Why do we have three different positions for storing the superblock?
>
> Bill> Why do you suggest changing anything until you get the answer to
> Bill> this question? If you don't understand why there are three
> Bill> locations, perhaps that would be a good initial investigation.
>
> Because I've asked this question before and not gotten an answer, nor
> is it answered in the man page for mdadm on why we have this setup.
>
> Bill> Clearly the short answer is that they reflect three stages of
> Bill> Neil's thinking on the topic, and I would bet that he had a good
> Bill> reason for moving the superblock when he did it.
>
> So let's hear Neil's thinking about all this?  Or should I just work
> up a patch to do what I suggest and see how that flies?
>
> Bill> Since you have to support all of them or break existing arrays,
> Bill> and they all use the same format so there's no saving of code
> Bill> size to mention, why even bring this up?
>
> Because of the confusion factor.  Again, since noone has been able to
> articulate a reason why we have three different versions of the 1.x
> superblock, nor have I seen any good reasons for why we should have
> them, I'm going by the KISS principle to reduce the options to the
> best one.
>
> And no, I'm not advocating getting rid of legacy support, but I AM
> advocating that we settle on ONE standard format going forward as the
> default for all new RAID superblocks.

Why exactly are you on this crusade to find the one "best" v1
superblock location?  Giving people the freedom to place the
superblock where they choose isn't a bad thing.  Would adding
something like "If in doubt, 1.1 is the safest choice." to the mdadm
man page give you the KISS warm-fuzzies you're pining for?

The fact that, after you read the manpage, you didn't even know that
the only difference between the v1.x variants is the location that the
superblock is placed indicates that you're not in a position to be so
tremendously evangelical about affecting code changes that limit
existing options.

Mike
