From: Mike Hardy <mhardy@h3c.com>
Subject: Re: A failed-disk-how-to anywhere?
Date: Sun, 09 Apr 2006 11:12:59 -0700
Message-ID: <44394EAB.5090309@h3c.com>
References: <C1F5413C-E9AB-4331-A901-1FBB645719DF@stender.com> <44391806.3000200@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44391806.3000200@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Martin Stender <martin@stender.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Brad Campbell wrote:
> Martin Stender wrote:
> 
>> Hi there!
>>
>> I have two identical disks sitting on a Promise dual channel IDE
>> controller. I guess both disks are primary's then.
>>
>> One of the disks have failed, so I bought a new disk, took out the
>> failed disk, and put in the new one.
>> That might seem a little naive, and apparently it was, since the
>> system won't boot up now.
>> It boots fine, when only the old, healthy disk is connected.


> My initial thought would be you have hde and hdg in a raid-1 and nothing
> on the on-board controllers. hde has failed and when you removed it your
> controller tried the 1st disk it could find (hdg) to boot of.. Bingo..
> away we go.
> You plug a new shiny disk into hde and now the controller tries to boot
> off that, except it's blank and therefore a no-go.
> 
> I'd either try and force the controller to boot off hdg (which might be
> a controller bios option) or swap hde & hdg.. then it might boot and let
> you create your partitions on hdg and then add it back into the mirror.


I'd add another stab in the dark and guess that you didn't install your
boot loader on both drives.

Not that I've ever done that before (ok, a few times, most recently two
days ago, sigh)

Typically the BIOS will try all hard drives and so it should have rolled
to one that worked, but if only the "failed" drive had the boot loader
then you are of course not bootable.

I solved this by booting rescue mode, starting up the raid arrays,
mounting them, and manually grub installing. Here's a good page for the
grub incantations:
http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID_mirror_and_LVM2_on_top_of_RAID#Bootloader_installation_and_configuration

-Mike
