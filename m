From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Full use of varying drive sizes?
Date: Tue, 22 Sep 2009 11:52:20 +0000
Message-ID: <73e903670909220452r2c4098c5w321f65c103b68a83@mail.gmail.com>
References: <697034.10751.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <697034.10751.qm@web51302.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 22, 2009 at 11:24 AM, Jon Hardcastle
<jd_hardcastle@yahoo.com> wrote:
> Hey guys,
>
> I have an array made of many drive sizes ranging from 500GB to 1TB and I appreciate that the array can only be a multiple of the smallest - I use the differing sizes as i just buy the best value drive at the time and hope that as i phase out the old drives I can '--grow' the array. That is all fine and dandy.
>
> But could someone tell me, did I dream that there might one day be support to allow you to actually use that unused space in the array? Because that would be awesome! (if a little hairy re: spare drives - have to be the size of the largest drive in the array atleast..?) I have 3x500GB 2x750GB 1x1TB so I have 1TB of completely unused space!
>
> Cheers.
>
> Jon H
>

Here's a thought:
Imaginary case: Say you have a 500, a 1000 and a 1500 GB drive. You
could JBOD the 500 and the 1000 together and mirror that against the
1500GB.

Disclaimer:
I don't know if it makes any sense to do this. I haven't seen this
method mentioned before, IIRC. It may be too esoteric to get any
press, or it may be simply stupid.

-- Kristleifur
