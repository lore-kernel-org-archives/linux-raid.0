From: Neil Brown <neilb@suse.de>
Subject: Re: Does software RAID take advantage of SMP, or 64 bit CPU(s)?
Date: Tue, 23 May 2006 16:26:40 +1000
Message-ID: <17522.43808.68998.902497@cse.unsw.edu.au>
References: <4472A9FF.9060501@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Adam Talbot on Monday May 22
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <talbotx@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 22, talbotx@comcast.net wrote:
> A few simple questions about the 2.6.16+ kernel and software RAID.
> Does software RAID in the 2.6.16 kernel take advantage of SMP?

Not exactly.  RAID5/6 tends to use just one cpu for parity
calculations, but that frees up other cpus for doing other important
work.

> Does software RAID take advantage of 64-bit CPU(s)?

No more or less that other code in the kernel.  Sometimes using a 64-bit
CPU is a cost because more data is shuffled around...

Was there some particular sort of 'advantage' that you were thinking
of?

NeilBrown


> If there are any good web sites that cover this information, a link
> would be GREAT!
> 
> -Adam Talbot
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
