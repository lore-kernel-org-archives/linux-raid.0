From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: New features?
Date: Tue, 31 Oct 2006 14:19:04 -0500
Message-ID: <4547A1A8.7000106@tmr.com>
References: <1162293818.32109.113.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1162293818.32109.113.camel@kenny>
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Rowe wrote:

>All this discussion has led me to wonder if we users of linux RAID have
>a clear consensus of what our priorities are, ie what are the things we
>really want to see soon as opposed to the many things that would be nice
>but not worth delaying the important things for. FWIW, here are mine, in
>order although the first two are roughly equal priority.
>
>1 "Warm swap" - replacing drives without taking down the array but maybe
>having to type in a few commands. Presumably a sata or sata/raid
>interface issue. (True hot swap is nice but not worth delaying warm-
>swap.)
>  
>
That seems to work now. It does assume that you have hardware hot swap 
capability.

>2 Adding new disks to arrays. Allows incremental upgrades and to take
>advantage of the hard disk equivalent of Moore's law.
>  
>
Also seems to work.

>3. RAID level conversion (1 to 5, 5 to 6, with single-disk to RAID 1 a
>lower priority).
>  
>
Single to RAID-N is possible, but involves a good bit of magic with 
leaving room for superblocks, etc.

>4. Uneven disk sizes, eg adding a 400GB disk to a 2x200GB mirror to
>create a 400GB mirror. Together with 2 and 3, allows me to continuously
>expand a disk array.
>  
>
???

-- 

bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

