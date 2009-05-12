From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm issue on Ubuntu Januty 9.04 server
Date: Tue, 12 May 2009 13:50:14 +1000 (EST)
Message-ID: <7b4fbb81cacca4588423fea9b919733f.squirrel@neil.brown.name>
References: <5817fbed0905111832u35d39a5au52482cceea53a4cb@mail.gmail.com>
    <f6ef7d922bea762a5b2539e4d015934a.squirrel@neil.brown.name>
    <5817fbed0905111907x1755a5deie9bf940eb522b69@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5817fbed0905111907x1755a5deie9bf940eb522b69@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: fibre raid <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 12, 2009 12:07 pm, fibre raid wrote:
> Thank you for the additional insight Neil.
>
> If I use partitions for my md members (like /dev/sdd1 and /dev/sdg1),
> do I run the --zero-superblock on /dev/sdd1 or /dev/sdd for example?

You use --zero-superblock on the same thing which, when used with
--examine, shows details of a raid array that you don't want.

> Finally, I am using Superblock v1.0 here, but in reviewing the mdadm
> thread archives, it seems that v1.2 is more commonly recommended. Is
> there any reason to use one or the other?

1.0 has the metadata at the end of the device
1.1 has it at the very beginning
1.2 has it just after the beginning of the device.

If you are making a raid1 and might in some case want to mount
just one of the devices without having md/raid in the way, then
1.0 is needed.
If the partition is a logical volume that you might want to grow,
then 1.1 or 1.2 is probably best.
There are probably other situations where one is clearly better than
another.  I don't have a full list though.

NeilBrown

