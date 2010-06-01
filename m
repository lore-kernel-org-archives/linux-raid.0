From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Tue, 1 Jun 2010 18:59:02 -0400
Message-ID: <AANLkTik9-CobthBnInKRvPF5lW5Vk4-vsLpCnksFjk-R@mail.gmail.com>
References: <AANLkTilamRIEvggIh7LX6sNNKwMJJVNK4gPuBQkGmkOv@mail.gmail.com>
	<AANLkTikeEC7QrcWq7nw5HiKtITcnM4jxDzM1ohC2ux0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikeEC7QrcWq7nw5HiKtITcnM4jxDzM1ohC2ux0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 1, 2010 at 1:56 PM, Mark Knecht <markknecht@gmail.com> wrote:
> On Tue, Jun 1, 2010 at 10:08 AM, Carlos Mennens <carloswill@gmail.com> wrote:
>> I built a new home server this weekend & am ready to load my O.S.
>> (Arch Linux) on it today. It has 4 x 320 GB Seagate Barracuda's
>> (SATA). I don't really have a specific function of this server at home
>> beyond holding my data reliably and decent read / write performance.
>> My question to you experts is what do you recommend I configure for
>> this particular configuration? Should I run RAID 5 or RAID 10? To
>> spare or not to spare? I really appreciate any best suggestions for
>> general over all function on this matter.
>>
>> -Carlos
>
> I'm not an expert so take my input with a grain of salt but you don't
> state how much space you need on the machine. Is 320GB enough? If so
> consider a 3-drive RAID1 and save the 4th drive as a spare. That's
> what I run using 3-drive 500GB WD drives. Works well over the last few
> months.
>
> Keep in mind that as a newbie, if you repeat any of my learning curve,
> booting from RAID is more difficult. I chose to not use RAID for the
> /boot sector and just duplicated the grub setup and kernel + grub
> files. If my Drive 0 goes down and I cannot I can reset the boot drive
> in BIOS and boot from the second or third drives.
>
> Hope this helps,
> Mark
> --

Besides that you have these options

RAID 5 with 3 drives and 1 spare - Gives you 640GB (320GB x 2) usable space
RAID 5 with 4 drives - Gives you 960GB (320GB x 3) usable space
RAID 6 with 4 drives - Gives you 640GB (320GB x 2) usable space
RAID 10 with 4 drives - Gives you 640GB (320GB x 2) usable space

If you need more than 640GB of space then RAID 5 across the 4 drives
is the way to go. Otherwise it comes down to performance and risk.
RAID 10 gives you the best performance and protects you from 1 disk
failure, possibly 2 if the correct drives fail. RAID 6 will protect
you from any 2 drive failures, but with more parity overhead than RAID
5.

I'm a big fan of RAID 10 if you can afford the space and need the
speed. Otherwise for smaller drives and spindles RAID 5 is great. If
you are using TB+ size drives across 5+ spindles RAID 6 is great for
reliability.

My home setup consists of 3 x 1TB drives in RAID 5. With hdparm I get
around 85MB/s on the drive and 130MB/s on the RAID 5. The array
resyncs at 85MB/s, which takes around 3 hours to complete. From my
Windows desktop over SMB I am getting around 30-50MB/s. Gigabit
Ethernet in a perfect world maxes out around 110MB/s.

Ryan
