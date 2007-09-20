From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: mke2fs stuck in D state while creating filesystem on md*
Date: Wed, 19 Sep 2007 21:19:02 -0400
Message-ID: <170fa0d20709191819w694cb7ddo37a19817ae4dfcad@mail.gmail.com>
References: <op.txtvfnrh88izfi@barton2> <46F010EE.3000202@tmr.com>
	 <op.tyv6r8sb88izfi@barton2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.tyv6r8sb88izfi@barton2>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Wiesner Thomas <thomas@bau-konform.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/19/07, Wiesner Thomas <thomas@bau-konform.at> wrote:
> > Has there been any progress on this? I think I saw it, or something
> > similar, during some testing of recent 2.6.23-rc kernels, on mke2fs took
> > about 11 min longer than all the others (~2 min) and it was not
> > repeatable. I worry that process of more interest will have the same
> > hang.
>
> Well, I must say: no. I haven't tried anything further. I've set up the
> production system a week or so ago
> which runs Debian Etch with no modifications (kernel 2.6.18 I think, the
> debian one and a mdadm 2.5.6-9).
> I didn't notice the problem while creating the raid but that doesn't mean
> anything as I didn't pay attention
> and as I wrote earlier it isn't reliably reproducable.
> (Watching it on a large storage gets boring very fast.)
>
> I'm not a kernel programmer but I can test another kernel or mdadm version
> if it helps, but let me know
> if you want me to do that.

If/when you experience the hang again please get a trace of all processes with:
echo t > /proc/sysrq-trigger

Of particular interest is the mke2fs trace; as well as any md threads.
