From: Daniel Jones <dj@iowni.com>
Subject: Re: Requesting assistance recovering RAID-5 array
Date: Mon, 30 Mar 2020 20:09:17 -0600
Message-ID: <CAB00BMg50zcerSLHShSjoOcaJ0JQSi2aSqTFfU2eQQrT12-qEg@mail.gmail.com>
References: <CAB00BMjPSg2wdq7pjt=AwmcDmr0ep2+Xr0EAy6CNnVhOsWk8pg@mail.gmail.com>
 <058b3f48-e69d-2783-8e08-693ad27693f6@youngman.org.uk> <CAB00BMgYmi+4XvdmJDWjQ8qGWa9m0mqj7yvrK3QSNH9SzYjypw@mail.gmail.com>
 <1d6b3e00-e7dd-1b19-1379-afe665169d44@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1d6b3e00-e7dd-1b19-1379-afe665169d44@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Phil,

> your new motherboard or your distro appears to have reacted to the presence of whole-disk raid members by establishing Gnu Partition Tables on them, blowing away those drives' superblocks.

Yes, this was an unpleasant surprise.  Won't build them this way again.

> In particular, knowledge of the filesystem or nested structure (LVM?) present on the array will be needed to identify the real data offsets of the three mangled members.

I don't have the history of original creation, but I'm fairly certain
it was something straightforward like:

  mdadm --create /dev/md0 {parameters}
  sudo mkfs.ext4 /dev/md0
  mount /dev/md0 /mnt/raid5

After the array was corrupted I needed to comment out the mount from
my fstab, which was as follows (confirming ext4):

    /dev/md0                                      /mnt/raid5
   ext4    defaults        0       0

Cheers,
DJ
