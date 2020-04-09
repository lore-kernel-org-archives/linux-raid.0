From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Repairing a RAID1 with non-zero mismatch_cnt, vol. 2
Date: Thu, 9 Apr 2020 08:19:40 +0100
Message-ID: <20200409071940.GA4072@cthulhu.home.robinhill.me.uk>
References: <CADSg1Jh1i+OPq0_hWOvHxK0xroUbn_w0_ZjxjwcnrbSsBXGY5A@mail.gmail.com>
 <5E25876A.1030004@youngman.org.uk>
 <CADSg1Jj3XmD_RmSedn3AT9uCXbHQGa6ATBK1UP33onS8Vi=60g@mail.gmail.com>
 <CADSg1Jh7=6XHXbDqWVWg=fa-+09Vd9E+KBuTy6AWucJesFkBmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADSg1Jh7=6XHXbDqWVWg=fa-+09Vd9E+KBuTy6AWucJesFkBmQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrey ``Bass'' Shcheglov <andrewbass@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu Apr 09, 2020 at 01:13:40AM +0300, Andrey ``Bass'' Shcheglov wrote:

> Now I have 3 empty ext4 partitions with only lost+found directories.
> 
> And the value of mismatch_cnt dropped to 384.
> 
> 
> Okay, so far, so good. I don't have any data, so a repair action can't
> possibly harm it.
> 
> > echo repair >>/sys/block/md4/md/sync_action
> 
> And the value of mismatch_cnt is still 384.
> 
The mismatch_cnt after repair indicates how many repairs were completed.
You need to run a new repair/check to see whether there are any
remaining mismatches.

Cheers,
    Robin
-- 
     ___        
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |
