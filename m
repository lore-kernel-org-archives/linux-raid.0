From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: RAID1 VS RAID5
Date: Sun, 26 Oct 2003 17:16:16 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310261716.17030.maarten@vbvb.nl>
References: <1067179519.1222.107.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1067179519.1222.107.camel@cala>
To: Mario Giammarco <mgiammarco@virgilio.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 26 October 2003 15:45, Mario Giammarco wrote:
> Hello,


> My problem is: I have seen that RAID1 code does not interleave reads so
> it does not improve performance very much putting two hard disks.

After thinking about your question for a minute, I think I found the obvious 
reason for that.  Raid1 being a mirror set it does not make sense to 
interleave anything. Either disk1 reads it first or disk2 reads it first. 
Once you get the data from either disk, then you're done; no need to wait for 
the second disk (giving you the identical datablock).  
Interleaving only makes sense with other raid levels, but not with level 1.

Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
