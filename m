From: Stefan Roese <stefan.roese@gmail.com>
Subject: Re: Convert RAID5 to RAID6 in a live system
Date: Wed, 23 Mar 2011 10:07:48 +0100
Message-ID: <201103231007.48693.stefan.roese@gmail.com>
References: <201103230843.59080.stefan.roese@gmail.com> <alpine.DEB.2.00.1103230905480.4842@uplift.swm.pp.se> <20110323131424.70a0e08a@natsu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110323131424.70a0e08a@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 23 March 2011 09:14:24 Roman Mamedov wrote:
> > > I'm currently in the process of converting a 3 disk RAID5 array into a
> > > 4 disk RAID5 array. I'm using mdadm 3.1.4 and Linux kernel
> > > 2.6.35-28-generic (Ubuntu). My questions now is this conversion save
> > > in a live (running) system? Or is this now allowed/supported?
> > 
> > I guess you wanted to say "4 disk RAID6 array"?
> > 
> > In that case, yes, I have done it on 2.6.32 and mdadm version (something
> > older) and it went just fine.
> > 
> > Neil wrote about it here <http://neil.brown.name/blog/20090817000931>.
> 
> Additionally, I suggest that you also check "man mdadm" and note the
> "--layout=preserve" option, if you use it, the RAID5 to RAID6 conversion
> while adding one disk will happen instantly, without restriping (but only
> with a resync of the new drive).

Thanks. I already started with this conversion, so this "--layout=preserve" is 
not an option for me any more. But good to know that this conversion should 
work. But its slow - it'll take approx. 4 days with my 2TB drives.

Best regards,
Stefan
