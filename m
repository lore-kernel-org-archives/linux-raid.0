From: "Niclas Arndt" <niclas@arndt.se>
Subject: GRUB2 MBR/GPT sizing question
Date: Wed, 15 May 2013 00:10:36 +0200
Message-ID: <d3d9bbafd33a3a4b9df641357a9d47aa.squirrel@mail.arndt.se>
Reply-To: niclas@arndt.se
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Sorry if this is slightly off-topic. I'm trying to figure out the HDD size
limitation using GRUB2 MBR-only with three md raid sets:

6*2 TB Samsung HD204UI partitioned like so:
Boot from sda MBR
15 GB / on raid1 pair ext4
15 GB swap on raid1 pair
32 MB unused fat16 per drive
1.9 TB /storage on raid 5 ext4 using all 6 drives

The above has been working flawlessly on openSUSE 11.3, 11.4, 12.2, and
initial install on 12.3. However, the first 12.3 kernel update replaced
GRUB2 with a failing GRUB0.97(!).

After much tinkering, I gdisk-converted the drives to a GRUB2 MBR+GPT with
the 32 MB partition used for grub_bios. This survives the kernel update,
so I think that I no longer have a problem. Either way, I would like to
understand if I was wrong or if the kernel update is misbehaving.

Surely, MBR supports 2TB drives with 512-byte sectors even though there is
a larger md raid?

Similarly, another identical server with 4*4TB Deskstar 7K4000 drives had
exactly the same MBR-only problem (also avoided by converting to MBR+GPT),
but in this case it might still work with 4kB sectors. (But I'm not sure
if this advanced format drive is actually using 4kB addressing rather than
512B emulation.)

Could somebody please shed some light on this?

Thanks in advance

Niclas
