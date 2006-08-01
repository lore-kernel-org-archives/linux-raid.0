From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 004 of 9] md: Factor out part of raid10d into a separate
 function.
Date: Tue, 01 Aug 2006 13:15:25 -0400
Message-ID: <44CF8C2D.2010900@tmr.com>
References: <20060731172842.24323.patches@notabene> <1060731073208.24470@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060731073208.24470@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

don't think this is better, NeilBrown wrote:

>raid10d has toooo many nested block, so take the fix_read_error
>functionality out into a separate function.
>  
>

Definite improvement in readability. Will all versions of the compiler 
do something appropriate WRT inlining or not?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

