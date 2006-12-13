From: Neil Brown <neilb@suse.de>
Subject: Re: Relabeling UUID
Date: Wed, 13 Dec 2006 11:29:02 +1100
Message-ID: <17791.18766.36228.208220@cse.unsw.edu.au>
References: <457F3BAD.6060206@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Tuesday December 12
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday December 12, davidsen@tmr.com wrote:
> I needed to move an array to other drives, and because of the way the 
> array is used, want to keep the UUID on the new array. It doesn't appear 
> that uuid= works with create (why?), or that stopping the array and then 
> using assemble with uuid= will renumber the array in the superblock.

 --update=uuid

> 
> What's the correct way to do this, or is it broken? And why can't I 
> specify uuid= in create?

Added to my 'todo' list - but no promises.

NeilBrown
