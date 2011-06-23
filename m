From: "Sandra Escandor" <sescandor@evertz.com>
Subject: can't read superblock after switching from dmraid
Date: Thu, 23 Jun 2011 14:23:46 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD37486@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

The current situation that I'm having is that when I give the command to
mount the RAID10, it reports back saying "mount: /dev/md126 can't read
superblock". 

The background is that, the RAID10 that I have was initially managed by
dmraid, but I tried moving it over to mdadm. Using dmraid, the RAID10
was initially created with an imsm metadata format, and an xfs
filesystem (mkfs.xfs -f -d su=64k,sw=2 -l su=64k). The steps that I took
to move over to mdadm are as follows:

1. uninstalled dmraid. 
2. Built mdadm 3.1.4 from source and installed it. 
3. Edited mdadm.conf to include output of "mdadm -Es" 
4. Issued "mdadm -As". After this command was issued, mdadm started a
resync of the drives. 

So when I issue the command to assemble the array, mdadm reports back
saying that the container /dev/md/imsm0 has been assembled with 4
drives, and that mdadm has started /dev/md/Volume0 with 4 devices. After
a while, when I look at the output of cat /proc/mdstat, it shows that
the resync has finished and that md126 is listed as "active
(auto-read-only)". 

When I look at the output of dmesg, it says "I/O error in filesystem
("md126") meta-data dev md126 block 0xaea8a9ff ("xfs_read_buf") error 5
buf count 512".

I tried doing an xfs_check on /dev/md126, but it didn't output anything.
I also did an xfs_repair on /dev/md126, and it looks like it didn't
encounter any errors.

I'm now stuck and am still searching for an answer on google. Can
someone point me to what could be wrong?

Thanks,
Sandra

