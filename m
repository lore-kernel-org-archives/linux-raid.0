From: Peter <thenephilim13@yahoo.com>
Subject: Re: kernel panic (2.6.23.1-fc7) in drivers/md/raid5.c:144
Date: Tue, 13 Nov 2007 11:22:56 -0800 (PST)
Message-ID: <460677.76280.qm@web52803.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Oops, I meant mdadm --detail /dev/md0 of course, not mdadm --examine
 /dev/md0

md: kicking non-fresh sdd1 from the array

I downgraded to 2.6.22.9-91.fc7 and that seems to be working so far, no
 kernel panics yet, trying to bring back sdd to the array. 


----- Original Message ----



Hi

I had a 3 disc raid5 array running fine with Fedora 7 (32bit) kernel
 2.6.23.1-fc7 on an old Athlon XP using a two sata_sil cards. 

I replaced the hardware with an Athlon64 X2 and using the onboard
 sata_nv, after I modified the initrd I was able to boot up from my old
 system drive. However when it brought up the raid array it died with a
 kernel panic. I used a rescue CD, commented out the array in mdadm.conf and
 booted up. I could assemble the array manually (it kicked out one of
 the three drives for some reason?) but when I used mdadm --examine
 /dev/md0 I got the kernel panic again. I don't have remote debugging but I
 managed to take some pictures:

http://img132.imageshack.us/img132/1697/kernel1sh3.jpg
http://img132.imageshack.us/img132/3538/kernel2eu2.jpg

From what I understand it should be possible to do this hardware
 upgrade with using software raid? Any ideas?

Thanks
Peter


-
To unsubscribe from this list: send the line "unsubscribe linux-raid"
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



