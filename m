From: Hari Bhaskaran <hbhaskaran@gmail.com>
Subject: Re: s/w raid and bios renumbering HDs
Date: Mon, 31 Oct 2005 15:59:38 -0800
Message-ID: <4366AFEA.6030906@gmail.com>
References: <8d03025a0510310756q7410ef13v6ffb4764229b2eb6@mail.gmail.com> <Pine.LNX.4.63.0510311126200.25465@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0510311126200.25465@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean-list-linux-raid@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

on 10/31/2005 11:47 AM dean gaudet said the following:
> huh i wonder if the bios has tweaked the ide controller to swap the 
> primary/secondary somehow -- probably cuts down on support calls for 
> people who plug things in wrong.  there could be a bios option to stop 
> this swapping.
>   
Not that I can see. Cheap dell machines like the one I have come with a 
single-page bios
setup screen. However, now I think it may not all be the bios. I have 
two more HDs connected
with an Adaptec pci-ide controller (which I plan to use for a raid-5). I 
will do some more experiments
so that I understand how this whole thing works.

> for raids other than the root raid you pretty much want to edit
> /etc/mdadm/mdadm.conf and make sure it has "DEVICE partitions" and has
>   
So that "DEVICE paritions" line was really supposed to be there? Hehe... 
I thought it was just a
help message and replaced it with "DEVICE /dev/hda1 /dev/hdc1" :)
> ARRAY entries for each of your arrays listing the UUID.  you can generate
> these entries with "mdadm --detail --scan" (see examples on man page).
>   
it took me a whole Sunday to figure that one out. I followed the howto, 
created the array and didn't know
how to start it back up after a reboot ( I hadn't asked mdadm to start 
raid devices at system startup). Even
when I did that, the array didn't come up until I put those ARRAY lines. 
I kept on editing raidtab - I hadn't read
the tiny print in mdadm manpage.

If I ever end up in a situation with a non-root raid down (say I did 
--stop), how do I start it back up? (--run seems
to give me some errors). Anyways, more "rtfm" to do.

> you can plug the non-root disks in any way you want and things will still
> work if you've configured this.
>   
That is nice.
> the root is the only one which you need to be careful with -- when debian 
> installs your kernel it constructs an initrd which lists the minimum 
> places it will search for the root raid components... for example on one 
> of my boxes:
>
> # mkdir /mnt/cramfs
> # mount -o ro,loop /boot/initrd.img-2.6.13-1-686-smp /mnt/cramfs
> # cat /mnt/cramfs/script
> ROOT=/dev/md3
> mdadm -A /dev/md3 -R -u 2b3a5b77:c7b4ab81:a2b8322a:db5c4e88 /dev/sdb4 /dev/sda4
> # umount /mnt/cramfs
>   
Did u install yours with raid options in the debian installer? I dont 
think my initrd image would have all these ( I dont have
access to the machine now to check) - but I wouldn't think the mkinitrd 
that I used to created the initrd image would
know that I am using raid or not ( I am talking about the mdadm 
references in your script). Or are you saying you
added these yourself?
> it's only expecting to look for the root raid components in those two
> partitions... seems kind of unfortunate really 'cause the script could
> be configured to look in any partition.
>
> in theory you can hand-edit the initrd if you plan to move root disks to
> another position... you can't mount a cramfs rw, so you need to mount,
> copy, edit, and run mkcramfs ... and i suggest not deleting your original
> initrd, and i suggest copy&pasting the /boot/grub/menu.lst entries to give
> you the option of booting the old initrd or your new made-by-hand one.
>
>
>   
>> title           Debian GNU/Linux, kernel 2.6.13.3-vs2.1.0-rc4-RAID-hda
>> root            (hd0,0)
>> kernel          /boot/vmlinuz-2.6.13.3-vs2.1.0-rc4 root=/dev/md0 ro
>> initrd          /boot/initrd.img-2.6.13.3-vs2.1.0-rc4.md0
>> savedefault
>> boot
>>
>> title           Debian GNU/Linux, kernel 2.6.13.3-vs2.1.0-rc4-RAID-hdc
>> root            (hd1,0)
>> kernel          /boot/vmlinuz-2.6.13.3-vs2.1.0-rc4 root=/dev/md0 ro
>> initrd          /boot/initrd.img-2.6.13.3-vs2.1.0-rc4.md0
>> savedefault
>> boot
>>     
>
> i don't think you need both.  when your first disk is dead the bios
> shifts the second disk forward... and hd0 / hd1 refer to bios ordering.
> i don't have both in my configs, but then i haven't bothered testing
> booting off the second disk in a long time.  (i always have live-cds
> such as knoppix handy for fixing boot problems.)
>
> -dean
>
>   

--
Hari

