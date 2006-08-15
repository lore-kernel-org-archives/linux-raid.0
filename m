From: andy liebman <andyliebman@aol.com>
Subject: Can you IMAGE Mirrored OS Drives?
Date: Tue, 15 Aug 2006 18:55:09 -0400
Message-ID: <44E250CD.5040308@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, I figured out how to take my existing OS installation from a 
single SATA drive and put it on a set of mirrored partitions on two 
different SATA drives. I looked at ALL of the "recipies" I could find on 
the Web -- none of them were quite right for MY situtation.

I will post my recipe here tomorrow for others to see -- maybe it will 
help somebody else. I just want to edit a few things to clarify before I 
post it. Some of the gotchas were were amusing -- like I couldn't run 
LILO on degraded raid1 arrays, and running "mkinitrd" from within 
Mandriva 2006 produces gzipped initrd files, but running "mkinitrd" by 
chrooting in from a LIVE CD produces initrd files that needs cpio to 
decompress and read it.

So, now that I have a running mirrored OS, I have a few more questions.

-- If I were to create disk images of EACH drive (i.e., /dev/sda and 
/dev/sdb), could I restore each of those images to NEW drives -- with 
all of their respective partitions -- and have a working RAIDED OS?  I 
ask because my ultimate goal is to put a RAIDED OS on many systems, and 
once I get ONE working, it would be nice to clone them the way I already 
clone SINGLE OS drives. Can you clone RAIDS? It would mean, of course, 
that the UUIDs would be the same on each system. Is that bad? Is there 
any risk here?

-- I know there was a lot of discussion on the list a while back about 
whether or not to mirror SWAP space. Was there ever any conclusion? It 
seems to me that mirroring will ensure that if one drive fails, you 
don't lose information in virtual memory. My applications rarely if 
every use virtual memory anyway so I'm not worried about speed. I want 
the ultimate in stabilty for the OS drive. Otherwise, I guess I would 
designate swap space on just one drive (but prepare identical partitions 
on each for swap). If the first drive failed (/dev/sda -- with the swap 
space), /dev/sdb would become the new /dev/sda anyway. And so fstab 
would be correct in pointing to /dev/sda.

Sound opinions welcome.

Thanks,
Andy Liebman
