From: Scott Laird <scott@sigkill.org>
Subject: Re: Irritating RAID problem (kept spare, kicked data disks due to timestamp)
Date: Mon, 10 Jan 2005 09:35:26 -0800
Message-ID: <03873167-632E-11D9-B5C2-000393667D82@sigkill.org>
References: <21F89945-6328-11D9-B5C2-000393667D82@sigkill.org> <200501101816.36581.maarten@ultratux.net>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101816.36581.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 10, 2005, at 9:16 AM, maarten wrote:
> Or rather, find out how the spare can have a newer timestamp, since 
> this is
> not something that should ever happen.  Afaik.  This might be a bug ?

Well, my disk controller locked up right before this happened, so it's 
probably possible that the timestamp writes to the other drives were 
lost.  I've went through disk hell over the past week reconstructing 
multiple failed RAID arrays (disk failure, my screwup, nothing 
mysterious, just irritating), and this is just the most recent problem. 
  I wouldn't necessarily read too much into how the timestamp weirdness 
happened.


Scott

