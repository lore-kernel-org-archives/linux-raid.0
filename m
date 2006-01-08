From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Sun, 08 Jan 2006 12:49:33 -0500
Message-ID: <43C150AD.1080601@tmr.com>
References: <E26C409DCE780347BD93D08771FF08E90129DB3D@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E26C409DCE780347BD93D08771FF08E90129DB3D@usahm236.amer.corp.eds.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Bailey, Scott" <scott.bailey@eds.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bailey, Scott wrote:

>Interestingly, I was just browsing this paper
>http://www.cs.utk.edu/%7Eplank/plank/papers/CS-05-569.html which appears
>to be quite on-topic for this discussion. I admit my eyes glaze over
>during intensive math discussions but it appears tuned RS might not be
>as horrible as you'd think since apparently state-of-the-art now
>provides tricks to avoid the Galois Field operations that used to be
>required.
>
>The thought that came to my mind was "how does md's RAID-6 personality
>compare to EVENODD coding?"
>
>Wondering if my home server will ever have enough storage for these
>discussions to become non-academic for me, :-) 
>
The problem is not having storage, it's having backup. The properties of 
backup are
- able to be moved to off-site storage
- cheap and fast enough to use regularly

Making storage more reliable is a desirable end, but it doesn't guard 
against many common failures such as controllers going bad and writing 
unreadable sectors all over before total failure, fire, flood, and 
software errors in the kernel code. While none of these is common in the 
sense of everyday, they are all common in the sense of "I never heard of 
that happening" response.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

