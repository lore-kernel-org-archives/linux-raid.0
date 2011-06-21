From: NeilBrown <neilb@suse.de>
Subject: Re: Which Disks can fail?
Date: Tue, 21 Jun 2011 20:45:09 +1000
Message-ID: <20110621204509.6309c38f@notabene.brown>
References: <4E007154.9030107@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E007154.9030107@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 21 Jun 2011 11:24:20 +0100 Jonathan Tripathy <jonnyt@abpni.co.uk>
wrote:

> Hi Everyone,
> 
> Use md's "single process" RAID10 with the standard near layout (which is 
> apperently the same as RAID1+0 in industry), which 2 drives could fail 
> without loosing the array?
> 
> This is what I have:
> 
> Number   Major   Minor   RaidDevice State
>         0       8        5        0      active sync   /dev/sda5
>         1       8       21        1      active sync   /dev/sdb5
>         2       8       37        2      active sync   /dev/sdc5
>         3       8       53        3      active sync   /dev/sdd5
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Run

   man 4 md

 search for "RAID10"

 read what you find, and if it doesn't make sense, ask again.
 If it does make sense, post your answer and feel free to ask for
 confirmation.


NeilBrown
