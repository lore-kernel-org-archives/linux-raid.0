From: Nathan Lewis <nathapl@cs.okstate.edu>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Sat, 31 Jan 2004 12:56:58 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20040131124325.03fafe78@a.cs.okstate.edu>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
 <16411.35140.244946.630202@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16411.35140.244946.630202@notabene.cse.unsw.edu.au>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
 <16411.35140.244946.630202@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 04:53 AM 1/31/2004, Neil Brown wrote:
>I strongly agree with Peter.  Base your work on 2.6, not 2.4.  The
>raid code is much cleaner in 2.6.

I'll take a look at 2.6 then and see what's different.  It may not be 
possible for me to use 2.6 due to restrictions on the test machines I'll be 
using.  I chose 2.4 because that's what was included in the distribution 
I'm using, it is what my professor is using on his machines, and it is the 
version covered by the Rubini book.  It seemed like a logical 
choice.  Where's the most comprehensive list of changes 2.4->2.6 dealing 
with block drivers and linux-raid?

>Good.  md/raid uses the make_request_fn function, not the request_fn
>function like most device drivers use.
>.....<snip>....

I really appreciate the answers to my questions.

>I too would be interest to see just how you would apply reed-solomon
>encoding to RAID.

In short, it is a distributed storage mechanism for a small (~50) group of 
workstations with a central coordinating server.  RS is needed for the high 
levels of redundancy possible.


