From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: Changing chunk size
Date: Fri, 16 Feb 2007 13:49:43 -0500
Message-ID: <45D5FCC7.7000503@maine.edu>
References: <45D4955C.60008@tmr.com> <17876.60347.983953.748979@notabene.brown> <45D5E05E.4000706@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45D5E05E.4000706@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Bill Davidsen wrote:
> 
> I'm sure "slow" is a relative term, compared to backing up TBs of data 
> and trying to restore them. Not to mention the lack of inexpensive TB 
> size backup media. That's totally unavailable at the moment, I'll live 
> with what I have, thanks.

You don't backup your RAID arrays?  Yikes! For certain data this would 
be fine (data that you can recreate easily) but it sounds like this 
isn't the case for you otherwise you'd just wipe the array and recreate 
the data. There are other modes of failure than just the drives 
themselves (file system corruption for instance) so it is wise to do 
backups, even on "redundant" systems.

Good luck,

Steve
-- 
______________________________________________________________________
  Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
  Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
  Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302


