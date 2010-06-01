From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Tue, 1 Jun 2010 10:56:57 -0700
Message-ID: <AANLkTikeEC7QrcWq7nw5HiKtITcnM4jxDzM1ohC2ux0Q@mail.gmail.com>
References: <AANLkTilamRIEvggIh7LX6sNNKwMJJVNK4gPuBQkGmkOv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilamRIEvggIh7LX6sNNKwMJJVNK4gPuBQkGmkOv@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 1, 2010 at 10:08 AM, Carlos Mennens <carloswill@gmail.com> wrote:
> I built a new home server this weekend & am ready to load my O.S.
> (Arch Linux) on it today. It has 4 x 320 GB Seagate Barracuda's
> (SATA). I don't really have a specific function of this server at home
> beyond holding my data reliably and decent read / write performance.
> My question to you experts is what do you recommend I configure for
> this particular configuration? Should I run RAID 5 or RAID 10? To
> spare or not to spare? I really appreciate any best suggestions for
> general over all function on this matter.
>
> -Carlos

I'm not an expert so take my input with a grain of salt but you don't
state how much space you need on the machine. Is 320GB enough? If so
consider a 3-drive RAID1 and save the 4th drive as a spare. That's
what I run using 3-drive 500GB WD drives. Works well over the last few
months.

Keep in mind that as a newbie, if you repeat any of my learning curve,
booting from RAID is more difficult. I chose to not use RAID for the
/boot sector and just duplicated the grub setup and kernel + grub
files. If my Drive 0 goes down and I cannot I can reset the boot drive
in BIOS and boot from the second or third drives.

Hope this helps,
Mark
