From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Wed, 13 Jul 2016 11:58:34 +0800
Message-ID: <25ed91c3-77aa-6046-f10c-565bc7dd85f9@fnarfbargle.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/07/16 05:09, Matt Garman wrote:
> We have a system with a 24-disk raid6 array, using 2TB SSDs.  We use
> this system in a workload that is 99.9% read-only (a few small
> writes/day, versus countless reads).  This system is an NFS server for
> about 50 compute nodes that continually read its data.


> Perhaps naively, I would expect that second-to-last line:
>
> [    6.499773] raid6: using algorithm avx2x4 gen() (8648 MB/s)
>
> to indicate what kind of throughput I could expect in a degraded
> state, but clearly that is not right---or I have something
> misconfigured.
>
> So in other words, what does that gen() 8648 MB/s metric mean in terms
> of real-world throughput?  Is there a way I can "convert" that number
> to expected throughput of a degraded array?

I can't help you with the throughput calculation, but 24 disks would 
imply you are striped across 22 disks.

With a reconstruct read, you of course have to read an entire stripe 
from all present disks to reconstruct that sector. So I would assume 
your machine IO to go through the roof, in addition to whatever 
calculations are required to actually do the reconstruction.

What is your chunk size?

