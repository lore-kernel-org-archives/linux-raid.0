From: Another Sillyname <anothersname@googlemail.com>
Subject: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Sun, 24 May 2015 02:18:45 +0100
Message-ID: <CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<555294A0.6040703@websitemanagers.com.au>
	<CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK.

I've now read a LOT of stuff on this and have a much better
understanding.....but also probably some misunderstandings as well
(but I've learnt a lot so that's good).

I have now realised that I can actually store the RAID configuration
within the mdadm.conf file and therefore can incorporate that into the
initramfs configuration, however I have a few areas of uncertainty
that perhaps some people on the list could clarify.

1.  Fedora currently has a bug whereby efibootmgr during the install
won't play nice with efi systems....

https://fedoraproject.org/wiki/Common_F21_bugs#Cannot_place_bootloader_target_partition_.28e.g._.2Fboot.2Fefi.29_on_a_disk_other_than_the_first_in_custom_partitioning

This causes the install to fail as the bootloader doesn't get installed.

As Fedora installs GRUB2 as standard and based on what I had read
elsewhere I decided to create a bios_boot partition as the first
partition on the drives, during the install GRUB2 sees this and
configures it appropriately thereby bypassing the bug above.

So I now have 5 partitions.

a  -  bios_boot
b  -  efi
c  -  boot
d  -  root
e  -  swap

I'll be adding one more when I'm happy this is working.

f  -  home

2.  On my Asus mobo that I'm using it insists on treating the
installed Live USB as sda.....frankly a real pain in the a** as it
means during the first boot the root partition is mapped incorrectly
to sdb4, not a major problem but still annoying so if anyone knows a
way to 'force' a USB stick to not be the first device I'd love to hear
it.

3.  Using the methods above I have now created a bootable fedora
system, on a single drive in preparation to now RAID the required
partitions.  However my concern comes regarding the mdadm metadata,
simplistically metadata=1.2 apparently writes it's superblock to 4k
after the start of the device, this is exactly where my efi partition
(b above) starts, so my concern is will this superblock overwrite or
mess with my current partition table?

4.  If the next stage works then I think what I'll actually end up
doing is......

scrub what I have now.

create the arrays before running the Fedora Live installer (this
assumes the installer will see /md[x] devices and allow them to be
used to install to). Then incorporate the mdadm.conf data into the
initramfs and regenerate initramfs.

Ideas/Thoughts/Criticisms?

Tony





On 13 May 2015 at 01:02, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 12/05/15 20:08, Another Sillyname wrote:
>>
>> I've tried to do some research on this but the information out there
>> seems a bit contradictory (mainly because some is so old).
>>
>> I want to install Fedora directly onto a RAID array (no separate boot
>> disk).
>>
>> My plan is to 'pre configure' the 6 drives as a clean RAID6 array,
>> effectively sd[a-f] without partitions and then attempt to install
>> Fedora 21, from sources it looks like Grub2 should recognise the array
>> and then allow the Kernel to boot thereby 'enabling' the array to
>> become visible and active.
>>
>> However I have not been able to find an actual example of someone
>> trying this......thoughts?
>>
>> The reason to do this is I'm intending to use a Mini ITX board with 6
>> sata ports and want to use 8TB drives in Raid6 to give me a very high
>> density data resilient small form factor storage box.
>>
>> Ideas/Suggestions?
>
>
> Create a small RAID1 partition at the beginning of every disk, use this for
> /boot and install grub. Use the rest of each disk as your RAID6 array.
>
> This means as long as the bios can find any one of your disks, then the
> system will boot. Personally, I'd be inclined to put the complete OS on the
> RAID1, and then only use the RAID6 for the "data" mountpoint. This would
> allow the system to come up fully, even without the RAID6 (eg, 4 out of 6
> drives has died), and allow remote debug/diagnostics/etc without needing to
> try and boot from a rescue disk/etc.
>
> This doesn't help you with what you asked, but just an idea/suggestion.
>
> Regards,
> Adam
>
> --
> Adam Goryachev Website Managers www.websitemanagers.com.au
