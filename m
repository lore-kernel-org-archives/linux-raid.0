From: "Shaw, Marco" <marco.shaw@nbtel.nb.ca>
Subject: RedHat Linux Advanced Server 2.1
Date: Sun, 22 Sep 2002 10:34:38 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA780BAD5B6F@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm sorry if RedHat covers some of these things in updates.  I've not been able to sign up my RHAS servers to the RedHat Network yet to see/get the appropriate updates.  (No I don't have an unsecure system connected to the 'net...  I don't have any connectivity at all.)

Running RHAS 2.1 (2.4.9-e.3smp) with raidtools 1.00.2-1.2.  I'm getting 3 errors that I'd like to ask you guys about.

1. invalid raid superblock

Dmesg:
<...snip...>
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
<...snip...>
md: invalid raid superblock magic on sda9
md: sda9 has invalid sb, not importing!
md: could not import sda9!
md: autostart sda9 failed!
md: nonpersistent superblock ...
md0: WARNING: sda10 appears to be on the same physical disk as sda9. True
     protection against single-disk failure might be compromised.
md: nonpersistent superblock ...
md: raid0 personality registered as nr 2
md0: max total readahead window set to 496k
md0: 2 data-disks, max readahead per data-disk: 248k
raid0: looking at sda9
raid0:   comparing sda9(1028128) with sda9(1028128)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sda10
raid0:   comparing sda10(1028128) with sda9(1028128)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: zone 0
raid0: checking sda9 ... contained as device 0
  (1028128) is smallest!.
raid0: checking sda10 ... contained as device 1
raid0: zone->nb_dev: 2, size: 2056256
raid0: current zone offset: 1028128
raid0: done.
raid0 : md_size is 2056256 blocks.
raid0 : conf->smallest->size is 2056256 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 8 bytes for hash.

I'm just in a testing phase, so yes, these devices are on the same device, which is a hardware RAID5 volume itself, if that matters any.

2. If I boot, I get an "invalid argument" message during the startup, but I'm not able to write it down, nor can I find it in any logfile.  Once the starupt completes, md0 still gets mounted, and appears good from mdstat.  So I did the following:
#umount /dev/md0; raidstop /dev/md0; raidstart /dev/md0

Output from raidstart /dev/md0: /dev/md0: Invalid argument

#cat /etc/raidtab
raiddev	/dev/md0
		raid-level			0
		nr-raid-disks		2
		chunk-size			32
		persistent-superblock	0
		device			/dev/sda9
		raid-disk			0
		device			/dev/sda10
		raid-disk			1


#rpm -q raidtools
raidtools-1.00.2-1.2

I tried an strace on raidstart, and it doesn't seem to reveal anything useful.

3. On boot, if I set "persistent-superblock" to 1, I'm dropped to single user mode after a message about persistent-superblock not being supported with RAID 0/Linear devices.  Again, I can't seem to capture the message from /var/log/*

Any ideas before I contact RedHat support?

Marco
