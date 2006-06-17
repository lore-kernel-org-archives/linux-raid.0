From: David Greaves <david@dgreaves.com>
Subject: Re: Raid5 software problems after loosing 4 disks for 48 hours
Date: Sat, 17 Jun 2006 22:42:34 +0100
Message-ID: <4494774A.50205@dgreaves.com>
References: <7c9ce5050606151659y219947e1g9f9034982d81221b@mail.gmail.com>	 <17554.1920.421692.780276@cse.unsw.edu.au> <7c9ce5050606170524l54f2b6i75e3472d313933b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c9ce5050606170524l54f2b6i75e3472d313933b0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Wilson <wilson150@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wilson Wilson wrote:
> Neil great stuff, its online now!!!
Congratulations :)
>
> I am still unsure how this raid5 volume was partially readable with 4
> disks missing.  My understanding each file is written across all disks
> apart from one, which is used for CRC.  So if 2 disks are offline the
> whole thing should be unreadable.
I'll try :)

md doesn't operate at a file level, it operates on chunks. The chunk
could be 64Kb in size.

For raid5 each stripe is made of n-1 chunks. (raid6 would be n-2).
When a stripe is read, if your file is in one of the chunks that's still
there then you're in luck.

I guess md knows it's degraded and gives as much data back as possible.

This means that you have a certain probability of accessing a given file
depending on it's size, the filesystem and the degree to which the array
is degraded.

FWIW I'd *never* try a r/w operation on such a degraded array.

Speculation:
I'm surprised you could mount such a 'sparse' array though. I wonder if
some filesystems (like xfs) would just barf as they mounted because they
have more distributed mount-time data structures and would spot the
missing chunks.  Others (ext3?) may just mount and try to read blocks on
demand.

David
