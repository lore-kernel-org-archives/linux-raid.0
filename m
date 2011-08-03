From: NeilBrown <neilb@suse.de>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Wed, 3 Aug 2011 19:20:54 +1000
Message-ID: <20110803192054.6097d2c0@notabene.brown>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
	<20110802163907.29fc40b4@notabene.brown>
	<CADz4AWEWm68H4ON=+StNE8epBfbnVHnSwJo+NjfTf8-w5Bd2Ug@mail.gmail.com>
	<20110803150108.58f5c70b@notabene.brown>
	<CADz4AWFekPKreuiwzYBvTnbXZnDGRH7nQ1WKEaeOdn7_6M5eQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADz4AWFekPKreuiwzYBvTnbXZnDGRH7nQ1WKEaeOdn7_6M5eQg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Scheiner <blue@aquarat.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Aug 2011 10:59:22 +0200 Aaron Scheiner <blue@aquarat.za.net> wrote:

> mmm, learning experience :P
> 
> The Wikipedia page on grub says :
> "
> Stage 1 can load Stage 2 directly, but it's normally set up to load
> Stage 1.5. GRUB Stage 1.5 is located in the first 30 kilobytes of hard
> disk immediately following the MBR and before the first partition.
> "
> So if both stage 1 and stage 1.5 were written to the drives
> approximately 30KBytes would have been overwritten, so 60 sectors?
> 
> Why is the data offset by 256 bytes ? The array was created using a
> standard create command (only specifying raid level, devices, chunk
> size).


The offset is 256 sectors (64K).

The data obviously cannot go at the start of the drive as the metadata is
there, so it is offset from the start.
I leave 64K to allow for various different metadata (bitmap, bad-block log,
other ideas I might have one day).

NeilBrown

