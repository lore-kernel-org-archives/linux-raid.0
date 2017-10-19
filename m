From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Thu, 19 Oct 2017 15:28:27 +0100
Message-ID: <59E8B68B.8090709@youngman.org.uk>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com>
 <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com>
 <59E7AE4B.5000903@youngman.org.uk>
 <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com>
 <59E88568.6060108@youngman.org.uk>
 <E62B1CBC-E39C-41A2-9795-623CF4FFE95F@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E62B1CBC-E39C-41A2-9795-623CF4FFE95F@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sean R. Funk" <sfunk1x@gmail.com>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 19/10/17 15:11, Sean R. Funk wrote:
> This is where I've been stuck. I read a post a couple nights ago about zeroing the superblock on the drives that report no superblock, but it seems they are already zeroed? My lack of experience here isn't helping.

Bummer. This is where I'll have to leave it. Did SELinux prevent the
superblocks being written? But in that case it should also have
prevented them being updated. I'm out of my depth.

There's some information out there about doing diagnostics by using hexdump.
https://raid.wiki.kernel.org/index.php/Advanced_data_recovery
This page is currently a work-in-progress, but maybe it'll give you a
few clues.

You'll probably be asked to boot into a rescue CD, if you can.

You'll need to have a copy of the latest mdadm on hand.

Any chance of running lsdrv from a rescue CD?

What I will say is do NOT do anything that will write to the drive
unless an expert is guiding you. You've had a reshape happen. That will
have moved data and stuff around on the disk. If you destroy the
existing superblocks they will be a *nightmare* to recreate, as stuff is
no longer in the default location.

Best of luck.

Cheers,
Wol
