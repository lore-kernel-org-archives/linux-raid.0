From: Nix <nix@esperi.org.uk>
Subject: Re: 4.10 + 765d704db: no improvemtn in write rates with md/raid5 group_thread_cnt > 0
Date: Tue, 11 Apr 2017 11:01:39 +0100
Message-ID: <874lxvgt4s.fsf@esperi.org.uk>
References: <87zifvj61v.fsf@esperi.org.uk>
        <20170410201057.qxypmzaw4gtmkwvd@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170410201057.qxypmzaw4gtmkwvd@kernel.org> (Shaohua Li's
        message of "Mon, 10 Apr 2017 13:10:57 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On 10 Apr 2017, Shaohua Li stated:

> On Wed, Apr 05, 2017 at 03:13:48PM +0100, Nix wrote:
>> So you'd expect write rates on a RAID-5 array to be higher than write rates on a
>> single spinning-rust disk, right? Because, even with Shaohua's commit
>> 765d704db1f583630d52 applied atop 4.10, I see little sign of it. Does this
>> commit depend upon something else to stop death by seeking with
>> group_thread_cnt > 0? It didn't look like it to me...
>> 
>> The results Shaohua showed in the original commit were very impressive, but for
>> the life of me I can't figure out how to get anything like them.
>
> That only works well with large iodepth. For single write, we are still far
> from the BW in theory. I actually wrote in the commit log:
>
> "We are pretty close to the maximum bandwidth in the large iodepth
> iodepth case. The performance gap of small iodepth sequential write
> between software raid and theory value is still very big though, because
> we don't have an efficient pipeline."

Ah right, I missed the significance of that. So this helps only if you
have multiple simultaneous multithreaded/async I/Os to the same file at
the same time? Damn, no help in any of my common use cases yet :( :( :(
except maybe massively-parallel compiles, but they are never write-bound
except when linking, and *that* is serial.

I guess I have to wait and hope for a better pipeline :)
