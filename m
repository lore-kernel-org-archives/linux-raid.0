From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Superblocks lost on 5/6 disks
Date: Sun, 23 Jul 2017 22:36:01 +0100
Message-ID: <597516C1.5050903@youngman.org.uk>
References: <1b693f6a-28e9-2a3a-7b62-2d9bdb52cf31@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1b693f6a-28e9-2a3a-7b62-2d9bdb52cf31@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: MasterPrenium <masterprenium.lkml@gmail.com>, linux-raid@vger.kernel.org
Cc: "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>
List-Id: linux-raid.ids

On 23/07/17 00:54, MasterPrenium wrote:
> The array which was originally built was a raid 5 with 5 drives, I grew
> it up to 6 drives in raid 6 when I had some hard drives failure.
> Everything was synchronised since a long time. At least a few months.

OWW!!!!

Combined with your --create --assume-clean, I think this means you have
a mess on your hands!!!

The data is probably recoverable, but DO NOT WRITE ANYTHING TO DISK !!!

Wait for the experts to chime in, but in the meantime, look at the wiki,
"When things go wrogn", and the page "mdadm says my array doesn't exist".

That'll tell you how to search for missing superblocks, file-system
signatures etc. I think that's where you're going to have to go to
recover your data ... hopefully it's not going to be too hard a job.

As I said, DO NOT let anything write to your disks until the experts
tell you what to do!

Cheers,
Wol
