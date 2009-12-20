From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Booting from RAID1
Date: Sat, 19 Dec 2009 23:34:46 -0600
Message-ID: <E7.83.01470.A77BD2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hey, everyone,

	It's me again.  Well, while I am still going to keep small offline
drive backups for my boot drives on the servers, I have decided to replace
the very small boot drives with some slightly larger RAID1 arrays.  To that
end, I've looked around the web for some good advice, and the best I have
found matching my system configuration seems to be this howto:

http://www.linuxhowtos.org/System/raid.htm

	I am a little unsure of one section, however.  In the section he
labels "Fix up initrd" he is suggesting I change the initrd in order to
allow booting from an md array rather than a sata drive.  I thought all 2.6
kernels supported booting from an array directly ( No? ).  Also, both of
these systems will have one PATA drive and one SATA ( seen as a "SCSI"
/dev/sdx drive ) drive in the RAID 1 arrays.  Does that make a difference?

	I will have three RAID 1 arrays: MD1 containing /boot on the first
partition, MD2 containing / on the second partition, and MD3 containing the
swap on the third partition of both drives.  One of the systems will also
have an NTFS partition on each drive for booting Windows - rarely used.  I
will be using grub as the bootloader.

	Any further advice?

