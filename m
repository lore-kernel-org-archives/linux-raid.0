From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6: help wanted
Date: Fri, 29 Oct 2004 14:33:47 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4182B73B.7030002@zytor.com>
References: <200410292121.i9TLLFN14796@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200410292121.i9TLLFN14796@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'Jim Paris' <jim@jtan.com>, 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> I took a look at your paper.  It's magic!  :)
> My head hurts. :(
> 
> Ok, I understand that 27 disks is the limit.  But is that usable?  Would it
> be too slow?  The disk IO seems unreasonable with 27 disks.

Shouldn't be too different from RAID-5, at least as long as you have 
reasonably large I/O transactions.

However, unless someone can actually test it out, it's hard to say.

Note that supporting RMW on RAID-6 is definitely a possibility; I tried it 
once on a 6-disk configuration (the only one I have) and it was slower.

	-hpa

