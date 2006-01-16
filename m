From: Andargor <andargor@yahoo.com>
Subject: Re: md faster than h/w?
Date: Mon, 16 Jan 2006 06:12:56 -0800 (PST)
Message-ID: <20060116141257.85428.qmail@web54604.mail.yahoo.com>
References: <43CB3033.8070803@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43CB3033.8070803@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- Max Waterman
<davidmaxwaterman+gmane@fastmail.co.uk> wrote:
> Of course, bonnie++ only works on mounted devices,
> but gives me
> reasonable (but not great) numbers (130MB/s) which
> don't seem to vary
> too much with the kernel version.

Out of curiosity, have you compared bonnie++ results
with and without -f (fast)?

I've found that it seems to report x2 read throughput
without -f. Perhaps it "warms up" the drive with
putc() and getc(), allowing the kernel and/or cache to
do its job?

I haven't found a benchmark that is 100%
reliable/comparable. Of course, it all depends how the
drive is used in production, which may have little
correlation with the benchmarks...

Andargor


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
