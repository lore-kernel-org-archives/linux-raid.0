From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Linux MD? Or an H710p?
Date: Mon, 21 Oct 2013 19:36:42 -0500
Message-ID: <5265C89A.4000908@gmail.com>
References: <526328AE.2020908@gmail.com> <21093.14265.261728.755087@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21093.14265.261728.755087@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First of all, thank you Stan, Mikael, and John for your replies.

Stan,

I had made a private bet with myself that Stan Hoeppner would be the 
first to respond to my query. And I was not disappointed. In fact, I was 
hoping for advice from you. We're getting the 7 yr hardware support 
contract from Dell, and I'm a little concerned about "finger-pointing" 
issues with regards to putting in a non-Dell SAS controller. Network 
card? No problem. But drive controller? Forgive me for "white-knuckling" 
on this a bit. But I have gotten an OK to order the server with both the 
H710p and the mystery "SAS 6Gbps HBA External Controller [$148.55]" for 
which no one at Dell seems to be able to tell me the pedigree. So I can 
configure both ways and see which I like. I do find that 1GB NV cache 
with barriers turned off to be attractive.

But hey, this is going to be a very nice opportunity for observing XFS's 
savvy with parallel i/o. And I'm looking forward to it. BTW, it's the 
problematic COBOL Point of Sale app that didn't do fsyncs that is being 
migrated to its Windows-only MS-SQL version in the virtualized instance 
of Windows 2008 Server. At least it will be a virtualized instance on 
this server if I get my way. Essentially, our core business is moving 
from Linux to Windows in this move. C'est la vie. I did my best. NCR won.

Mikael,

That's a good point. I know that at one time RHEL didn't get that right 
in its Grub config. I've been assuming that in 2013 it's a "taken for 
granted" thing, with the caveat that nothing involving the bootloader 
and boot sectors can ever be completely taken for granted.

John,

First, let me get an embarrassing misinterpretation out of the way. "HYB 
CARR" stands for "hybrid carrier" which is a fancy name for a 2.5" -> 
3.5" drive mounting adapter.

Fortunately, this is a workload (varied as it is) with which I am 
extremely familiar. Yes, Firefox uses (abuses?) memory aggressively. But 
if necessary, I can control that with system-wide lockprefs. This 
server, which ended up being a Dell R720, will have an insane 256GB of 
memory in a mirrored configuration, resulting in an effective (and half 
as insane) 128GB visible to the OS. In 7 years time that should seem 
about 1/25th as insane as that. And we'll just have to see about the 50% 
memory bandwidth hit we see for mirroring.

But anyway, I know that 16GB was iffy for the same workload 5 years ago. 
And we've expanded a bit. I think I could reasonably run what we're 
doing now on 24GB. Which means that we'd probably need something between 
that and 32GB, because my brain tends to underestimate these things. We 
currently are running on 48GB, which is so roomy that it makes it hard 
to tell.

-Steve

