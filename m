From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: XFS or JFS? (Was: > 2TB ?)
Date: Fri, 11 Feb 2005 23:10:08 +0100
Message-ID: <62b0912f050211141029ce8a94@mail.gmail.com>
References: <09d601c50fb1$b9c9df10$020a0a0a@musicroom>
	 <l6vsd2-blf.ln1@news.it.uc3m.es>
	 <62b0912f0502110132630b3ae4@mail.gmail.com>
	 <420CB61E.5030305@update.fsix.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <420CB61E.5030305@update.fsix.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Knowlton wrote:
> Molle Bestefich wrote:
>>Linux filesystems seems to stink real bad when they span multiple
>>terabytes, at least that's my personal experience.  I've tried both
>>ext3 and reiserfs.  Even simple operations such as deleting files
>>suddenly take on the order of 10-20 minutes.
>>
> I'm running some 3TB software arrays (12 * 250GB RAID5) with no
> trouble.  I've opted for XFS over ext3 or reiserfs, and I see no trouble
> in accessing or deleting files.

Is there anybody out there with a qualified opinion on what is best
suited for TB arrays, XFS or JFS?

> not a problem.  Well, as far a software RAID goes anyway - I wish it
> handled trivial media errors more gracefully (ie, without dropping
> disks).  You should always back-up your data.

Second that.  MD is not the brightest thing around.
I particularly dislike the game where you have a failed disk and
accidentally yank a cable on another disk, and MD increases the usage
counter on the remaining (unusable) disks in the array.  Plugging in
and out disks while rebooting Linux to see if you can get the counters
to match and MD to assemble the array again does give that nice
adrenalin surge, but I still prefer the more relaxing desktop games
that come with Linux.
