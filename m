From: "Michael T. Babcock" <mbabcock@fibrespeed.net>
Subject: Re: smart raid1 reads?
Date: Mon, 11 Aug 2003 14:27:23 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F37E00B.2000006@fibrespeed.net>
References: <3F378CF3.7030809@fibrespeed.net> <200308111119.32344.nick@byu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200308111119.32344.nick@byu.edu>
To: Nicholas Leippe <nick@byu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nicholas Leippe wrote:

>I don't know about the internals either, but it's already issuing block 
>writes to both drives in parallel, I don't see why synchronization is an 
>issue.  Block layers don't usually care about serialization--that is left  to the filesystem and higher os levels, no?  If so, I would think it shouldn't matter--md1 is in effect here the new block layer--merging two other block devices into one--nothing should be bypassing that layer for any blocks in the partition it's using.
>  
>

Part of what bothers me is that even without parallelizing for one large 
read, if there are multiple queued reads from one RAID1 device that 
aren't nearby (see elevator code), then read the second set from the 
second drive, the third set from the first drive, and so on to minimize 
head movement.

-- 
Michael T. Babcock
C.T.O., FibreSpeed Ltd.
http://www.fibrespeed.net/~mbabcock


