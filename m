From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: Re: md faster than h/w?
Date: Tue, 17 Jan 2006 17:18:30 +0800
Message-ID: <dqicp8$47j$1@sea.gmane.org>
References: <43CB3033.8070803@fastmail.co.uk> <20060116141257.85428.qmail@web54604.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060116141257.85428.qmail@web54604.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andargor wrote:
> 
> --- Max Waterman
> <davidmaxwaterman+gmane@fastmail.co.uk> wrote:
> 
>>Of course, bonnie++ only works on mounted devices,
>>but gives me
>>reasonable (but not great) numbers (130MB/s) which
>>don't seem to vary
>>too much with the kernel version.
> 
> 
> Out of curiosity, have you compared bonnie++ results
> with and without -f (fast)?

Nope. Just used default options (as well as the '-u' and
'-d' options, of course).

> 
> I've found that it seems to report x2 read throughput
> without -f. Perhaps it "warms up" the drive with
> putc() and getc(), allowing the kernel and/or cache to
> do its job?

Hrm.

> 
> I haven't found a benchmark that is 100%
> reliable/comparable. Of course, it all depends how the
> drive is used in production, which may have little
> correlation with the benchmarks...

Indeed.

Do you think that if it is configured for the best possible
read performance, then that would be it's worst possible
write performance?

I was hoping that having it configured for good read perf.
would mean it was pretty good for write too....

Max.

> 
> Andargor
> 
> 
> __________________________________________________
> Do You Yahoo!?
> Tired of spam?  Yahoo! Mail has the best spam protection around 
> http://mail.yahoo.com 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

