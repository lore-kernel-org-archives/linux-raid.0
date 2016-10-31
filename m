From: Peter Hoffmann <Hoffmann.P@gmx.net>
Subject: Re: Panicked and deleted superblock
Date: Mon, 31 Oct 2016 23:36:39 +0100
Message-ID: <9d0bf300-73e8-9109-c630-03f392fc820e@gmx.net>
References: <0e68051d-1008-cf9b-1f8f-0a0736b1c58f@gmx.net>
 <20161030194326.GA6727@metamorpher.de>
 <7f1dd791-ed1c-5db6-555d-ed377995420e@gmx.net>
 <20161030211103.GA7196@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161030211103.GA7196@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm a bit confused using the overlay function.

(A) If I follow the manual on the wiki [1] the new raid device md0
seemingly just contains random junks of byte, nothing like the header of
the original decrypted device.
(B) But if I copy say 400M of each original drive at least the hexdump
looks like the head of an ext4 file system and is what I expected from
looking at the original decrypted device

Steps for (A):

    for ((i=0; $i < 3; i++ )); do
      dev=/dev/mapper/HDD_$i

      dd if=/dev/zero of=overlay-$i bs=4M count=100 # alternative 1
      # truncate -s1850G overlay-$i # alternativ 2

      loop=$(losetup -f --show -- overlay-$i)
      echo 0 $(blockdev --getsize $dev) snapshot $dev $loop P 8 | \
        dmsetup create HDD_overlay_0_$i
    done
    mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0
/dev/mapper/HDD_overlay_0_[012] missing

Steps for (B):

    for ((i=0; $i < 3; i++ )); do
      dd if=/dev/mapper/HDD_$i of=copy-$i bs=4M count=100
      loops="$loops $(losetup -f --show -- copy-$i"
    done
    mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md1
$loops missing
	
Both ways should look exactly the same at least for the first 1200M,
shouldn't they?

Greetings
P. Hoffmann


1)
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

Am 30.10.2016 um 22:11 schrieb Andreas Klauer:
> On Sun, Oct 30, 2016 at 09:45:27PM +0100, Peter Hoffmann wrote:
>> there shouldn't anything be lost as growing consumes more
>> than it writes, stripe wise speaking
> 
> That's what I meant by 'overlap' - it's the wrong word I guess.
> 
>> /dev/sda2 --luks--> /dev/mapper/HDD_0 \
>> /dev/sdb2 --luks--> /dev/mapper/HDD_1 --raid--> /dev/md127 -ext4-> /raid
>> /dev/sdc2 --luks--> /dev/mapper/HDD_2 /
> 
> You're hoping it be faster since three threads instead of one?
> Adds the overhead of encrypting parity. Not sure if worth it.
> This idea belongs to another era (before AES-NI).
> 
> But it's good, that way, you have "unencrypted" data on your RAID and can 
> make deductions from that raw data as to chunk size and such things. 
> 
>> * anything else?
> 
> This is where I don't know how to provide specific help.
> Since you did not provide specific data I can work with.
> Your data offset sounds strange to me but with overlay, 
> it's faster to just go ahead and try.
> 
> You'll have to figure out the details by yourself, pretty much.
> 
> Once you have the correct offset you might be able to deduct the other 
> offset. Create 4 loop devices size of your disks (sparse files in tmpfs, 
> truncate -s thefile, losetup), create a 3 disk raid, grow to 4 disks, 
> check with mdadm --examine if & how the data offset changed.
> 
>> So I'm looking for a sequence of bytes that is duplicated on both
>> overlays. This way I find the border between both parts.
> 
> Yes, there should be an identical region (let's hope not zeroes)
> and you should roughly determine the end of that region and that's 
> your entry point for a linear device mapping.
> 
> Regards
> Andreas Klauer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
