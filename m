From: "Shaw, Marco" <marco.shaw@nbtel.nb.ca>
Subject: 3 questions...
Date: Fri, 27 Sep 2002 20:51:50 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA780BAD5C7B@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

1. When using fdisk, is it really required (or a "good idea") to create the partitions as type "fd"?  I've typically just created a regular Linux partition, and would let mkraid to it's thing.  (As a result, it seems strange that I ran into #2 below since I didn't do this step of changing the type.)

2. I can't seem to find a document describing how software RAID really works technically.  (Yes, I could read the source, but I'm not the most proficient C person, nor do I want to work all weekend looking at the source either.)  I had a problem the other day, where I had a md0 device that the system was not able to mount (logical disks mounted from a SAN).  Because the system could not mount the disks, it would fail to boot at the section where the system would attempt to auto-detect md0 and would drop me to single-user mode type prompt.

Taking the directory out of fstab, and tried to find something in /etc/rc.d/init.d that was trying to do stuff with the md devices at boot but couldn't find anything.  Ended up being a problem with an old modular driver, and had to create a new initrd with an updated driver, but I was stuck for a second (well more than a second really).

3. Is "persistent-superblock" supported with Linear and RAID0?  I think chunk-size is only supported in RAID0 and higher, but Linear will just skip the configuration with an informational warning at boot.

Marco

PS Basing some of my assumptions/statements above from the Software-RAID HOWTO v. 0.90.7.
