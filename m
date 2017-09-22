From: Roman Mamedov <rm@romanrm.net>
Subject: Re: ServeRAID-BR10i (LSI SAS1068E) strageness
Date: Fri, 22 Sep 2017 13:36:12 +0500
Message-ID: <20170922133612.25963e72@natsu>
References: <74846504-299c-1d75-d6e9-8fbe8b603f52@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <74846504-299c-1d75-d6e9-8fbe8b603f52@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 22 Sep 2017 18:11:36 +1000
Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> In short, no ata?.00 devices

This can be normal, one controller I use now is "LSI Logic / Symbios Logic SAS2008 PCI-Express
Fusion-MPT SAS-2" (mpt3sas driver) and it also does not use the ata devices at all.

$ ls /sys/block/sd* -la
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sda -> ../devices/pci0000:00/0000:00:11.0/ata1/host1/target1:0:0/1:0:0:0/block/sda
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdb -> ../devices/pci0000:00/0000:00:11.0/ata2/host2/target2:0:0/2:0:0:0/block/sdb
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdc -> ../devices/pci0000:00/0000:00:11.0/ata3/host3/target3:0:0/3:0:0:0/block/sdc
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdd -> ../devices/pci0000:00/0000:00:11.0/ata4/host4/target4:0:0/4:0:0:0/block/sdd
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sde -> ../devices/pci0000:00/0000:00:11.0/ata5/host5/target5:0:0/5:0:0:0/block/sde
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdf -> ../devices/pci0000:00/0000:00:11.0/ata6/host6/target6:0:0/6:0:0:0/block/sdf
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdg -> ../devices/pci0000:00/0000:00:02.0/0000:01:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sdg
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdh -> ../devices/pci0000:00/0000:00:02.0/0000:01:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdh
lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdi -> ../devices/pci0000:00/0000:00:02.0/0000:01:00.0/host0/port-0:2/end_device-0:2/target0:0:2/0:0:2:0/block/sdi

3 disks on the SAS2008 controller.

> and no 'sdc: sdc1' partition list.

Did you check if there is the actual /dev/sdc1 present? Tried to access/mount/re-add it to RAID?

-- 
With respect,
Roman
