From: "Michael T. Babcock" <mbabcock@fibrespeed.net>
Subject: Re: smart raid1 reads?
Date: Mon, 11 Aug 2003 08:32:51 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F378CF3.7030809@fibrespeed.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Nicholas Leippe <nick@byu.edu>
List-Id: linux-raid.ids

>
>
>In a raid0, of course, reads pull off every disk in parallel, thus performance 
>scales with # of disks.
>
>However, with raid1, it does not do this--it always reads from just one half 
>of the mirror.  Why doesn't it read from both halves of the mirror in 
>parallel?  I would expect it to, and would expect raid1 to perform similar to 
>raid0 for reads.
>  
>

I was looking for more information on why this is myself today.  Its 
quite possible that the complexity is too great for anyone to be willing 
to try it yet.  After all, if you want to read off of disk 0 and disk 1 
at the same time, you need to be sure the data you're reading doesn't 
include any blocks waiting to be sync'd from the other drive.

I don't know what the in-memory structures look like for 'blocks waiting 
to be sync'd', but depending on their design, this could be easier said 
than done.

-- 
Michael T. Babcock
C.T.O., FibreSpeed Ltd.
http://www.fibrespeed.net/~mbabcock


