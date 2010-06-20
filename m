From: aragonx@dcsnow.com
Subject: Re: How to boost performance [SOLVED]
Date: Sun, 20 Jun 2010 19:30:07 -0400
Message-ID: <6048c257b28c2c1461166f5e1eea0346.squirrel@www.dcsnow.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
    <20100617100109.32a20ffa@natsu>
    <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
    <20100617221300.3e30afe0@natsu>
    <db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
    <20100618020220.161c54b2@natsu> <20100617204327.GA21864@rap.rap.dk>
    <ccb4516c0633bda40a3160130d385c2b.squirrel@www.dcsnow.com>
    <AANLkTinV3i0vpR9i4_VCbcrGEqxoLGfQY_SrgDftQwJ_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinV3i0vpR9i4_VCbcrGEqxoLGfQY_SrgDftQwJ_@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you all for your many suggestions.

After performing all the tweaks suggested, I was able to write a 5GB file
from my workstation to my server at 100MB/sec!!!  Reads (from the server)
are equally as fast and are mainly limited by my workstation now.  The
server has dual bonded gigabit NICs so it can throw the data pretty fast.

Here is what I did:

echo 16384 > /sys/block/md0/md/stripe_cache_size
Added to /etc/fstab for md0:   barrier=1,journal_checksum,stripe=5
Switched to AHCI mode for both my SATA controllers
One of my disks in the BIOS was not set to 32bit transfer mode where the
others were.  I changed that.
And finally my kernel version changed when I rebooted.  I'm not sure if it
is relevant but thought it should be noted:  2.6.32.14-127.fc12.x86_64
instead of 2.6.32.11-99.fc12.x86_64.

Additionally, it should be noted that my wait states went down to about
2-3% while writing to the array (instead of 20-40%) and CPU usage was only
about 40% total instead of maxed.

dd if=/dev/zero of=zerofile bs=1M count=6144 conv=fdatasync,notrunc
6144+0 records in
6144+0 records out
6442450944 bytes (6.4 GB) copied, 37.1289 s, 174 MB/s

Thank you all for your help!

---
Will Y.


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

