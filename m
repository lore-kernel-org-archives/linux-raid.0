From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH] Revert "md: raid1: use bio helper in process_checks()"
Date: Tue, 28 Mar 2017 16:43:07 +0100
Message-ID: <58DA848B.7030308@youngman.org.uk>
References: <20170328095029.3500369-1-arnd@arndb.de>
 <CACVXFVMX=0XBvSt7b-3XObw3SknPGqH9JZvT6jViYbZfzKqQEg@mail.gmail.com>
 <CAK8P3a0k9S-t1CvpcabNVJOFMWoieuSn6EEr4oB72+T=zQT=aw@mail.gmail.com>
 <CACVXFVNzGV+P9CXcyqcV0_rJVM9F7dOR3_aX2xv0GQTsMaXX6A@mail.gmail.com>
 <CAK8P3a1yV0M_3TwM2QkEKqL-teKNEcWRXuG4_GT27pM+rFoBPw@mail.gmail.com>
 <CACVXFVMWORnxVtuokRp=N1ELAk4UbkOr0n-hM2MOTbO7HLhLtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVXFVMWORnxVtuokRp=N1ELAk4UbkOr0n-hM2MOTbO7HLhLtw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, "colyli@suse.de" <colyli@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Mike Christie <mchristi@redhat.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On 28/03/17 16:02, Ming Lei wrote:
>> What I meant is that a future change to the function might cause
>> > another bug to go unnoticed later.

> What is the future change? And what is another bug? Please don't suppose or
> assume anything in future.

What was that about some American General demanding a list of "unknown
unknowns"?
> 
> BTW, I don't think it is a problem, and anyone who want to change the code
> much should understand it first, right?
> 
I'm very sorry, but I think you are assuming facts not in evidence (or
rather, facts that the evidence says are wrong).

In real life, it is normal for people to change things without
understanding them. Are you saying that *you* - a couple of years down
the line - will remember this bit of code, and will block a mistaken patch?

What Arnd is doing is commonly called "defensive programming", and
unfortunately reality shows us that it is usually worth its weight in
gold. That's why you put ASSERTs in code - so that if somebody does
something stupid by accident, it blows up. This is just more of the same.

Cheers,
Wol
