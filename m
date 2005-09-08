From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Thu, 8 Sep 2005 21:34:09 +0200
Message-ID: <62b0912f0509081234326cc15a@mail.gmail.com>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
	 <Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:
> Is there a documented procedure to follow during
> creation or after that will get a raid6 array to self
> rebuild ?

MD will rebuild your array automatically, given that it has a spare disk to use.

> raid5: Disk failure on sde, disabling device. Operation continuing on 35 devices

Seems like a raid5, not raid6..

> [UU_UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]

No need to do any rebuilding on the remaining devices, since the data
on them are fine.

You've lost redundancy however, so you should add a new disk to the array ASAP.

With 35 disks, I'd recommend that you at least use raid6 in place of raid5..
