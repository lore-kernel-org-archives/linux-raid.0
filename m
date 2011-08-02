From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Tue, 02 Aug 2011 11:41:25 -0500
Message-ID: <4E3828B5.2050202@hardwarefreak.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com> <20110802163907.29fc40b4@notabene.brown> <4E37AEE8.1080108@hardwarefreak.com> <CADz4AWFJHah=OkZ0JaC8ZZD+E13D6tOvhz7cRR0oc19OfsOQew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADz4AWFJHah=OkZ0JaC8ZZD+E13D6tOvhz7cRR0oc19OfsOQew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Scheiner <blue@aquarat.za.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/2/2011 11:24 AM, Aaron Scheiner wrote:
> wow... I had no idea XFS was that complex, great for performance,
> horrible for file recovery :P . Thanks for the explanation.
> 
> Based on this the scalpel+lots of samples approach might not work...
> I'll investigate XFS a little more closely, I just assumed it would
> write big files in one continuous block.

Maybe I didn't completely understand what you're trying to do...

As long as there is enough free space within an AG, any newly created
file will be written contiguously (from the FS POV).  If you have 15
extent AGs and write 30 of these files, 2 will be written into each AG.
 There will be lots of free space between the last file in AG2 and AG3,
on down the line.  When I said the data would not be contiguous, I was
referring to the overall composition of the filesystem, not individual
files.  Depending on their size, individual files will be broken up
into, what, 128KB chunks, and spread across the 8 disk stripe, by mdraid.

> This makes a lot of sense; I reconstructed/re-created the array using
> a random drive order, scalpel'ed the md device for the start of the
> video file and found it. I then dd'ed that out to a file on the hard
> drive and then loaded that into a hex editor. The file ended abruptly
> after about +/-384KBs. I couldn't find any other data belonging to the
> file within 50MBs around the the sample scalpel had found.

What is the original size of this video file?

> Thanks again for the info.

Sure thing.  Hope you get it going.

-- 
Stan
