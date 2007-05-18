From: "Colin McCabe" <colin.p.mccabe@gmail.com>
Subject: Re: unreadable drives can be synchronized?
Date: Fri, 18 May 2007 14:18:16 -0400
Message-ID: <7296208f0705181118n32537ddck4d94bed08625b79f@mail.gmail.com>
References: <200705181447.l4IElO2a000640@cichlid.com>
	 <464DC06F.2080609@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <464DC06F.2080609@wpkg.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Andrew Burgess <aab@cichlid.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/18/07, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Andrew Burgess schrieb:
> >> Basically, B appears to be "write-only"; it will never return an error on a
> >> write, but just try to read from it, and you will be sorry.
> >
> > It would be interesting to see what SMART says about drive B, especially
> > the short and long self tests.
>
> I wouldn't rely on SMART.
>
> I have a broken drive, which has lots of badblocks - but SMART happily
> claims it's fine (short/long tests are completed without errors).
>

If you haven't seen Google's hard drive study yet, you should take a look.
It's at http://labs.google.com/papers/disk_failures.pdf

The conclusion says that "some of the SMART parameters are
well-correlated with higher failure probabilities," but also that "a
large fraction of [google's] failed drives have shown no SMART error
signals whatsoever."

Colin
