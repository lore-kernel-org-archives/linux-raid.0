From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Checking consistency of Linux software RAID
Date: Mon, 30 Jun 2003 14:13:57 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0306301411220.31613-100000@unicorn.drogon.net>
References: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 30 Jun 2003, Martin Bene wrote:

> Is there any way to do this with SW raid? I truly hate situations where
> some sectors on a drive fail silently and you don't notice until a 2nd
> drive dies and you find you can't recostruct your raid data becaus of
> silent "bitrot".

Try

	badblocks -v -s /dev/md0

Check the man page for various options, etc.

You might actually want to read the raw partitions rather than reading
through the md driver - eg. badblocks /dev/hda1, etc. so do this twice for
each partition of a RAID1, and N times for each slice of a RAID5 ...

Gordon


