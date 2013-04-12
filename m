From: keld@keldix.com
Subject: Re: Raid10 Reshape/Grow
Date: Fri, 12 Apr 2013 09:17:00 +0200
Message-ID: <20130412071700.GA7613@www5.open-std.org>
References: <51676986.40303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51676986.40303@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim White <weirdit@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have outlined strategies to grow raid10 earlier in earlier mails on this list.
I think it is doable. Why not try to implement it like that?

Best regards
Keld

On Fri, Apr 12, 2013 at 11:55:18AM +1000, Tim White wrote:
> I recently watched Neil's LCA2013 video, and so was wondering if RAID10 
> reshape/grow is ever going to be implemented?
> 
> The way I see it, if we are adding pairs of disks to the RAID10 array 
> (not necessarily the same size as current disks, but the pair being the 
> same size), then we should be able to reshape to grow the RAID10.
> 
> From what I can see, the current options are to not use RAID10 if we 
> want to be able to expand later, or to use LVM over RAID1.
> 
> I'm obviously not expecting it to be in any distro's yet, but am just 
> wondering what the state of these features are. I have a mdadm git 
> checkout, and am willing to do testing to assist with this.
> 
> Thanks
> 
> Tim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
