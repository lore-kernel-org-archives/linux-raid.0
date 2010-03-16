From: Keld Simonsen <keld@keldix.com>
Subject: Re: RAID1 On 3 Drives
Date: Tue, 16 Mar 2010 02:46:00 +0100
Message-ID: <20100316014600.GA25649@light.rap.dk>
References: <4B9C11FB.7040604@gmx.net> <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com> <4B9C24B6.7040507@tmr.com> <d80f793f1003150530y1b229f43s1f140f91ab74f3e8@mail.gmail.com> <70ed7c3e1003150548v65dce098ud62ddfbcc0747d49@mail.gmail.com> <d80f793f1003150747h203aa5c4kc80375f4250f4532@mail.gmail.com> <70ed7c3e1003150905x63605be5r6ee5874e60069e4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e1003150905x63605be5r6ee5874e60069e4b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 15, 2010 at 07:05:17PM +0300, Majed B. wrote:
> 100-200 MB is good enough for the /boot filesystem.
> 
> How much swap to use depends on how much RAM you have and how much RAM
> the applications you use demand.
> If you have 4GB RAM or more, and most of your usage is about browsing
> the Internet, documents, watching videos, ..etc., then 2GB swap is
> more than enough even though I think you'll never use it.
> In case you ever need more than that, you could also create a
> swap-file -- whenever in need, create the file with the size you need
> on your array, activate the file as swap and that's it! When done with
> it, deactivated and delete the file to reclaim the capacity it once
> occupied.
> 
> Personally, I keep my /home on its own partition. This guarantees that
> whatever system upgrades or distribution installs occur, /home won't
> be affected nor touched, and can be seen by multiple Linux distros if
> you're into multi-booting.
> 
> I have a workstation with 4x 320GB disks with my root filesystem on it
> as RAID5. I have to say that it wasn't a good judgment going that way.
> One time one of the disks failed and the system refused to boot in
> degraded mode, so I had to boot from a CD, resync the array and then
> boot normally.
> That event got me thinking: Why don't I put / on its own disk and
> /home be on the RAID5 array. I could copy / to the array as a backup,
> should the OS disk crash; put a new disk, make it bootable, install
> grub on it, then using a LiveCD I could boot and access my RAID5 array
> and copy the OS files back.
> 
> It's OK to have all disks running on the array without a spare. Just
> make sure you configure smartd and have it run tests on a daily basis
> (short tests) and a weekly basis (long tests) and to have it email you
> if problems occur.
> 
> For RAID performance enhancements, the page seem to have been removed
> but a cached version of it is available:
> http://74.125.77.132/search?q=cache:5f7lyJQGL78J:www.linuxfoundation.org/collaborate/workgroups/linux-raid/performance+http://linux-raid.osdl.org/index.php/Performance&cd=1&hl=en&ct=clnk

Our wiki moved ... see
http://raid.wiki.kernel.org/index.php/Performance

> 
> For RAID benchmarks:
> https://turing.phas.ubc.ca/mediawiki/index.php/RAID_benchmarks

does not involve Linux MD RAID. Linux MD RAID is generally faster then
HW RAID.

Best regards
keld
