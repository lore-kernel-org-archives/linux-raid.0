From: "J. David Beutel" <jdb@getsu.com>
Subject: Re: RAID1 robust read and read/write correct patch
Date: Wed, 23 Feb 2005 10:48:58 -1000
Message-ID: <421CEC3A.5010609@getsu.com>
References: <421C628D.8080908@getsu.com> <p97ue2-1ld.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <p97ue2-1ld.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote, on 2005-Feb-23 1:50 AM:

> Quite possibly - I never tested the rewrite part of the patch, just
>
>wrote it to indicate how it should go and stuck it in to encourage
>others to go on from there.  It's disabled by default.  You almost
>certainly don't want to enable it unless you are a developer (or a
>guinea pig :).
>  
>

Thanks for taking a look at it!  Unfortunately, I'm not a kernel 
developer.  I haven't even been using C for the last 8 years.  But I'd 
really like to have that rewrite functionality, and I can dedicate my 
system as a guinea pig for at least a little while, if there's a way I 
can test it in a finite amount of time and build some confidence in it 
before I start to really use that system.

I'd like to start with an md unit test suite.  Is there one?  I don't 
know if the architecture would allow for this, but naively I'm thinking 
that the test suite would use a mock disk driver (e.g., in memory only) 
to simulate various kinds of hardware failures and confirm that md 
responds as expected to both the layer above (the kernel?) and below 
(the disk driver?).  Unit tests are also good for simulating unlikely 
and hard to reproduce race conditions, although stress tests are better 
at discovering new ones.   But, should the test suite play the roll of 
the kernel by calling md functions directly in a user space sandbox 
(mock kernel, threads, etc)?  Or, should it play the roll of a user 
process by calling the real kernel to test the real md (broadening the 
scope of the test)?  I'd appreciate opinions or advice from kernel or md 
developers.

Also, does anyone have advice on how I should do system and stress tests 
on this?

Cheers,
11011011


