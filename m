From: William Knop <wknop@andrew.cmu.edu>
Subject: Re: libata badness
Date: Mon, 4 Oct 2004 23:11:08 -0400 (EDT)
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60-041.0410042301510.22333@unix47.andrew.cmu.edu>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu>
 <16737.54003.419130.575839@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <16737.54003.419130.575839@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids


> This code starts:
>
>   0:   8b 55 04                  mov    0x4(%ebp),%edx
>   3:   83 c1 08                  add    $0x8,%ecx
>
> and as %ebp is 01000000, this oopses.
> It looks very much like a single-bit memory error (as has already been
> suggested as a possibility).

Oh my. So, I ran memcheck again for a few hours, and it checked out fine. 
Just in case, though, I bought a replacement stick of ram. Well, the 
oopses went away, so it must have been the ram.

Sigh. Sorry about that, everyone. I suppose the raid operations are 
particularly memory intensive. Anyway, thanks a ton for all the help.

Will
