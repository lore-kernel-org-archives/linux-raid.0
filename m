From: Benjamin Meier <post@benjaminmeier.de>
Subject: Bug: Different data offsets while reshaping scrambles data
Date: Thu, 20 Jun 2013 11:05:29 +0200 (CEST)
Message-ID: <1581788480.3.1371719130029.open-xchange@jupiter>
Reply-To: Benjamin Meier <post@benjaminmeier.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I think that I have found a bug which scrambled my data seriously. I don't know
what has happened exactly but I was lucky enough to reproduce the situation.
After reducing my (degraded) RAID-5 array from 5 to 4 discs, the data (LVM
superblock, filesystem etc.) wasn't recognized anymore. My suggestion is that is
has something to do with different data offsets I used on the devices. As the
default data offset has changed over time and the array consists over years
there have been different offsets on the discs. Chunk sizes were the same
(512k). With this I can reproduce the faulty behavior like below.

It would be great if I can understand what went wrong here so that I can restore
some of my data (I don't have a backup of _every_ file on that array).


# Produce three virtual discs connected to loop-devices
for i in {1..3}; do dd if=/dev/zero of=disc$i bs=512k count=512; losetup
/dev/loop$i disc$i; done

# Use "special" mdadm to simulate different data offsets which have been used as
defaults over the years, othernwise mdadm v3.2.5 - 18th May 2012 was used
(shiped with debian)
git clone -b data_offset git://neil.brown.name/mdadm
cd mdadm; make; cd ..
mdadm/mdadm --create /dev/md300 --level=5 --raid-devices=3 --assume-clean
/dev/loop1:4096s /dev/loop2:178176s /dev/loop3:262144s

# Produce some testdata which will get scrambled by the bug (only produce 128M
because we will reduce the array size to this value later)
dd if=/dev/urandom of=testdata bs=1M count=128
dd if=testdata of=/dev/md300

# Completely remove one of the discs
mdadm --manage /dev/md300 --fail /dev/loop1
mdadm --manage /dev/md300 --remove /dev/loop1
mdadm --zero-superblock /dev/loop1

# Shrink the array by one device and wait for reshape and resync to be finished
mdadm --grow /dev/md300 --array-size 131072
mdadm --grow /dev/md300 --raid-devices=2 --backup-file=backup

# Compare the array-data with the testdata - they differ :-(
dd if=/dev/md300 of=checkdata bs=1M count=128
md5sum testdata checkdata

Greetings from germany!
