From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: optimal IO scheduler choice?
Date: Thu, 13 Dec 2007 06:24:15 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712130621490.2285@p34.internal.lan>
References: <20071213075217.GA8241@apartia.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071213075217.GA8241@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 13 Dec 2007, Louis-David Mitterrand wrote:

> Hi,
>
> after reading some interesting suggestions on kernel tuning at:
>
> 	http://hep.kbfi.ee/index.php/IT/KernelTuning
>
> I am wondering whether 'deadline' is indeed the best IO scheduler (vs.
> anticipatory and cfq) for a soft raid5/6 partition on a server?
>
> What is the common wisdom on the subject among linux-raid users and
> developers?
>
> Thanks,
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I have found anticipatory to be the fastest.

http://home.comcast.net/~jpiszcz/sched/cfq_vs_as_vs_deadline_vs_noop.html

Sequential:
Output of CFQ: (horrid): 311,683 KiB/s
  Output of AS: 443,103 KiB/s

Input CFQ is a little faster.

It depends on your workload I suppose.

Justin.

