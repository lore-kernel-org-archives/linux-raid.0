From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Mar 2011 09:12:59 -0400
Message-ID: <4D8B435B.5040606@gmail.com>
References: <4D837DAF.6060107@hardwarefreak.com>	<20110319090101.1786cc2a@notabene.brown>	<4D8559A2.6080209@hardwarefreak.com>	<20110320144147.29141f04@notabene.brown>	<AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>	<4D868C36.5050304@hardwarefreak.com>	<20110321024452.GA23100@www2.open-std.org>	<4D875E51.50807@hardwarefreak.com>	<20110321221304.GA900@www2.open-std.org>	<20110322094658.GA21078@cthulhu.home.robinhill.me.uk>	<20110322101403.GA9329@www2.open-std.org>	<4D89B519.3020907@hardwarefreak.com> <AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com> <4D8A1D9B.7020100@gmail.com> <4D8AFB2E.7080203@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D8AFB2E.7080203@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/24/2011 04:05 AM, Stan Hoeppner wrote:

>> At the end of the day, it will be *far* more economical to build a
>> distributed storage cluster with a parallel file system atop it, than
>> build a single large storage unit.
>
> I must call BS on the "far more economical" comment.  At the end of the

I find it funny ... really, that the person whom hasn't designed and 
built the thing that we have, is calling BS on us.

This is the reason why email filters were developed.

In another email, Neil corrected some of Stan's other fundamental 
misconceptions on RAID writing.  Christoph corrected others.  Free 
advice here ... proceed with caution if you are considering using *any* 
of his advice, and get it sanity checked beforehand..

[...]

>> We've achieved well north of 10GB/s

It is important to note this.  We have.  He hasn't.

One thing we deal with on a fairly regular basis are people slapping 
components together that they think will work, and having expectations 
set really high on the performance side.  Expectations get moderated by 
experience.  Those who've done these things know what troubles await, 
those who don't look at spec's, say I need X of these, Y of those and my 
performance troubles will be gone.  It doesn't work that way.  Watching 
such processes unfold is akin to watching a slow motion train wreck on a 
movie ... you don't want it to occur, but it will, and it won't end well.

>> sustained reads and writes from thousands of simultaneous processes
>> across thousands of cores (yes, with MD backed RAIDs being part of
>> this), for hundreds of GB reads/writes (well into the TB range)
>
> That's great.  Also, be honest with the fine folks on the list.  You use
> mdraid0 or linear for stitching hardware RAID arrays together, similar
> to what I mentioned.  You're not using mdraid across all 48 drives in

Again, since we didn't talk about how we use MD RAID, he doesn't know. 
Then constructs a strawman and proceeds to knock it down.

I won't fisk the rest of this, just make sure that, before you take his 
advice, you check with someone that's done it.  He doesn't grok why one 
might need lots of ram in a read heavy scenario, or how RAID writes 
work, or ...

Yeah, you need to be pretty careful taking advice on building RAID or 
high performance scalable file server systems like this from people whom 
haven't, are guessing, and getting their answers corrected at a deep 
fundamental level by others.

[...]

> Fortunately for the readers here, such unworthy designs you mention
> aren't posted on this list.

... says the person whom hasn't designed/built/tested configurations 
that the other group they are criticizing has successfully deployed ...

As a reminder of thread history, he started with singing the praises of 
the Nexsan FC targets, indicated MD raid wasn't up to the task, that it 
wasn't "a professionally used solution" or similar statement.  Then he 
attacked anyone who disagreed, and pointed out flaws in his 
statement/argument.  When people like me (and others) suggested cluster 
file systems, he went on his single system design way, and again, using 
FC/SAS, decided that a linear stripe was the right approach.

Heh!

Nothing to see here folks, adjust your filters accordingly.

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
