From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: [RFCI] How best to partition MD/raid devices in 2.6
Date: Fri, 14 Nov 2003 16:27:51 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87smkrecyw.fsf@enki.rimspace.net>
References: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16308.18387.142415.469027@notabene.cse.unsw.edu.au> (Neil
 Brown's message of "Fri, 14 Nov 2003 14:11:15 +1100")
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 14 Nov 2003, Neil Brown wrote:

[...]

>  3/ define minor numbers of block-major-9 that are larger than 255 to
>    have 6 bits of partitioning information. i.e.
>      9,0 -> md0
>      9,1 -> md1
>       ...
>      9,255 -> md255
>      9,256 -> md256
>      9,257 -> md256p1
>      9,257 -> md256p2
>       ...
>      9,320 -> md257
>      9,321 -> md257p1
>       ...
>    This has least impact on other system and is in some ways simplest,
>    but it has the problem of lack of uniformity.  You wouldn't be able
>    to partition md0, but that isn't a big problem as long as you can
>    partition some md arrays.

How about assigning the partition space above 

  9,0 => md0
  9,1 => md1
  ...
  9,257 => md0p1
  9,258 => md0p2
  ...
  9,320 => md1p1

That should be sensibly backward compatible, I think, and still allow
all the MD devices to be partitioned.

    Daniel

-- 
No, no, you're not thinking, you're just being logical.
        -- Niels Bohr
