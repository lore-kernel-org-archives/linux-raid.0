From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Are piggybacking of write and redirection of read available in
 md driver now?
Date: Tue, 16 Oct 2012 09:39:32 +0100
Message-ID: <507D1D44.3050807@anonymous.org.uk>
References: <CAEuG+X+b6wr=291NbH5=LR0gSSBVHG_JcWSgk7_SKnBtRaxHrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEuG+X+b6wr=291NbH5=LR0gSSBVHG_JcWSgk7_SKnBtRaxHrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hui jiao <simonjiaoh@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/10/2012 06:44, hui jiao wrote:
> there were two optimizations-redirection of reads and piggybacking of
> writes-which first introduced in paper "Performance Analysis of Disk
> Arrays under Failure" 16th VLDB conference 1990.
>
> redirection of reads: the user accesses to data that has already been
> reconstructed are serviced by (redirected to) the replacement disk,
> rather than invoking on-the-fly reconstruction as they would if the
> data were not yet available.

As I understand it, that's done automatically. If there is a 
reconstruction in progress, any read from the completed half is read 
from the replacement disc, but any read from the still-to-do half is 
reconstructed (obviously).

> piggybacking of writes: the user reads that cause on-the-fly
> reconstruction also cause the reconstructed data to be written to the
> replacement disk.

No, that doesn't happen, because it would require a bitmap of which 
areas of the discs were reconstructed rather than a progress pointer.

> have these two features been implemented in md driver now? if so,
> where i can find them? if not, is there any plan on them?

I can't see the second one making any significant difference in practice 
unless you're writing to your array so much that the reconstruction time 
is dramatically delayed, though maybe the paper you referred to says 
differently. I don't think there's a plan for it, but check out Neil 
Brown's blog at http://neil.brown.name/blog/ - and it's possible that 
you get it as a side-effect of the bad block log that's being 
developed/tested at the moment.

Cheers,

John.

