From: Neil Brown <neilb@suse.de>
Subject: Re: Ooops on read-only raid5 while unmounting as xfs
Date: Wed, 24 Jan 2007 10:54:12 +1100
Message-ID: <17846.40996.525616.51618@notabene.brown>
References: <fd8d0180701180218o66a48176q172b029673c22660@mail.gmail.com>
	<17845.25989.10063.901037@notabene.brown>
	<fd8d0180701230642rd9d35e9y7e1058546254bad4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francois Barre on Tuesday January 23
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday January 23, francois.barre@gmail.com wrote:
> 
> My question is then : what prevents the upper layer to open the array
> read-write, submit a write and make the md code BUG_ON() ?

The theory is that when you tell an md array to become read-only, it
tells the block layer that it is read-only, and then if some process
tries to open it read/write, it gets an array.

I say "theory" because I have never really tested any of the read-only
stuff.  I have had a feeling for a long time that it really needs a
bit of thought and testing and documentation, but it never quite
seemed important enough to get that love-and-care....

NeilBrown
