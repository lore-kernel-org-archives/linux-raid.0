From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Mon, 22 Jan 2007 09:57:49 -0500
Message-ID: <45B4D0ED.7030500@maine.edu>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f> <Pine.LNX.4.64.0701220717200.30260@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701220717200.30260@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: kyle <kylewong@southa.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Justin Piszcz wrote:
> Yes, I noticed this bug too, if you change it too many times or change it 
> at the 'wrong' time, it hangs up when you echo numbr > 
> /proc/stripe_cache_size.
> 
> Basically don't run it more than once and don't run it at the 'wrong' time 
> and it works.  Not sure where the bug lies, but yeah I've seen that on 3 
> different machines!

Can you tell us when the "right" time is or maybe what the "wrong" time 
is?  Also, is this kernel specific?  Does it (increasing 
stripe_cache_size) work with RAID6 too?

Thanks,

Steve
-- 
______________________________________________________________________
  Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
  Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
  Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302


