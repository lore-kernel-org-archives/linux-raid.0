From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 recovery: reads and writes
Date: Tue, 16 Dec 2008 08:09:01 +1100
Message-ID: <18758.51053.866819.442495@notabene.brown>
References: <cccedfc60812150545s7159f0a2x2fa7f36ecf8d9c60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> I have a software raid1 which underwent a recovery recently.
> While it was recovering, I could not understand why I was seeing an
> equal amount of *read* I/O as write I/O to the device the raid1 was
> recovering to. That's to say, the raid1 was rebuilding on to a spare
> but instead of just writing I was seeing (nearly exactly) the same
> amount of read I/O as write I/O. The non-spare device was getting
> almost exclusively read I/O as expected. Why was the spare getting any
> read I/O at all?

It sounds like it is doing a 'repair' rather than a 'recover'.
'repair' happens when you write the word 'repair' to
/sys/block/mdX/md/sync_action.

In situations like this it is always best to provide lots of detail.
e.g. kernel logs of the time when things were happening, "mdadm -E" or
all devices.  The exact data you looked at to make you think there was
something going wrong (in this case, whatever statistics you found
that suggested lots of read requests).

Without those specifics it is hard to try to reproduce, and hard to
guess what was actually happening.

NeilBrown
