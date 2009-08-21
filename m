From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: linux disk access when idle
Date: Fri, 21 Aug 2009 18:10:39 -0500
Message-ID: <20090821231039.GB22331@sewage>
References: <20090820163522.GA29215@sewage> <4A8F190B.9010406@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A8F190B.9010406@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 21, 2009 at 06:00:43PM -0400, Bill Davidsen wrote:
> /proc/sys/vm/dirty_expire_centisecs still set to 30 sec?

$ cat /proc/sys/vm/dirty_expire_centisecs
2999

Yup.  Maybe I don't understand exactly what this does, but if the
drives are idle (i.e. no reads or writes) for say an hour or more,
why would there be any dirty data to flush?

That's why I'm confused---this machine literally goes for hours at a
time without and read or write attemps on these drives.

-Matt

