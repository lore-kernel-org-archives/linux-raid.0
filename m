From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --detail output: 2 questions
Date: Tue, 4 May 2004 12:21:12 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16534.65048.920279.41796@cse.unsw.edu.au>
References: <20040422175833.GA30298@bluff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sandro Dentella on Thursday April 22
To: Sandro Dentella <sandro.dentella@tin.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 22, sandro.dentella@tin.it wrote:
> Hi all, 
> 
>   I made a raid5 array with command
> 
>    mdadm -Cv /dev/md3 -n5 -x1 -l5  /dev/sd{a,b,c,d,e,f}1
> 
>   It took me a while to undertand that while syncing a raid5 mdadm --detail
>   marks as failed the spare disk + 1. Is that correct? here the output before
>   it was finished and afterwords. The last one really was produced by mdadm 1.5,
>   the first one by mdadm 1.2, since 

Yes. That is correct.  Rebuilding a drive is faster than correcting
all parity blocks, so mdadm prefers that approach.

> ##########################################################################
> 
> in both output I see 7 'Total devices' and 1 Failed but I don't have any
> failed in reality nor in the last part of the output. Am I misunderstanding
> the output? 

No, the kernel isn't quite keeping track of things properly.

> 
> Last question: what is the meaning of  'Events: 0.2' (0.1 during
> syncing)?

Just a sequence number of superblock updates.

NeilBrown
