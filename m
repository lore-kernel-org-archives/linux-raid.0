From: linux-raid@ied.com
Subject: looking for cheap(er) RAID
Date: Fri, 19 Sep 2003 17:59:32 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <no.Yo.20700.N.nN.0309191740020@business.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hi guys,

  I've spent on this at least 2hrs now and still am w/out a
clue.

  I could get a HPT372-based HW RAID, but found a lot of
reports on the net of haslles associated. Looked into
TX2000, but found not positive reports on the net. (I am
planning to install Mandrake 9.1 on a server.)

  I searched wide and deep on google "linux recommended 
raid", but nothing reasonably current turned up.

  FAQ at http://linas.org/linux/raid.html covers no uptodate 
recommendation for linux RAID hw.

  Could someone please tell me (a FAQ) of a cheap(er) RAID,
where I could install out-of-the-box Mandrake 9.1 ? (I would
like the boot & root fs to be on the RAID as well.) BTW, I
have IDE drives, not SCSI drives.

  My HW is Intel P42.4 533FSB (RB) CPU, ASUS P4BGLMX-533.

  How much slower would it be with software RAID ? Could we 
have boot & root on software raid (for now just two disks 
mirrorred). I imagine boot wouldn't care, since it is just 
mirrored. But would MDK installation work ? Or should I just 
dd if=/dev/hda1 of=/dev/hdc1 ; mount -o remount /dev/md... /
after installation ?


   Thanks in advance !

      John

-- 
-- Gospel of Jesus' kingdom = saving power of God for all who believe --
                 ## To some, nothing is impossible. ##
