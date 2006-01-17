From: Andargor <andargor@yahoo.com>
Subject: Re: md faster than h/w?
Date: Tue, 17 Jan 2006 09:09:01 -0800 (PST)
Message-ID: <20060117170901.84523.qmail@web54604.mail.yahoo.com>
References: <dqicp8$47j$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dqicp8$47j$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- Max Waterman
<davidmaxwaterman+gmane@fastmail.co.uk> wrote:

> Andargor wrote:
> > 
> > I haven't found a benchmark that is 100%
> > reliable/comparable. Of course, it all depends how
> the
> > drive is used in production, which may have little
> > correlation with the benchmarks...
> 
> Indeed.
> 
> Do you think that if it is configured for the best
> possible
> read performance, then that would be it's worst
> possible
> write performance?
> 
> I was hoping that having it configured for good read
> perf.
> would mean it was pretty good for write too....
> 
> Max.
> 

I don't have nearly the expertise some people here
show, but intuitively I don't think that's true. If
anything, it would be the opposite, unless write
caching was as good as read caching (both h/w and
kernel). Also, the number of disks you have to write
to or read from depending on RAID level has an impact.

And as Mark Hahn has indicated, the actual location on
disk you are reading/writing has an impact as well.
Difficult to evaluate objectively.

So, basically, I don't have an answer to that. :)

Andargor






__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
