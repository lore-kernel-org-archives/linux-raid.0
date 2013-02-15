From: Daniel Browning <db@kavod.com>
Subject: Growing a raid60 (Was: Re: Best practice for large storage?)
Date: Thu, 14 Feb 2013 17:49:04 -0800
Message-ID: <201302141749.04573.db@kavod.com>
References: <CAH3kUhGVt1iyn9tt=2-+f6H++obOGSK3x0pBBPZV8CFUXjp5yw@mail.gmail.com> <CAH3kUhHG=jqKB1BdNh5YxR-TfE4Wh4-eOrGduhu2ksWtO4LJtA@mail.gmail.com> <511D8901.2020803@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511D8901.2020803@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: Roberto Spadim <rspadim@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday 14 February 2013 5:01:53 pm Adam Goryachev wrote:
> If you did not need to grow the space, then you would use RAID60, and do
> striping, but I think you can't grow that, although some pages I just read
> suggest it might be possible to grow a raid0 by converting to raid4 and
> back again.

Those pages you just read are correct, except that md does the whole raid4 
conversion for you behind the scenes, automatically. Obviously, the 
transformation takes a while as it re-balances the raid accross the new 
member, but it's online and read-write the whole time. When it's done, the 
array looks as if it was created that way. You can even change the chunk size 
(if desired) with a little off-array temporary storage.

I attached a script that demonstrates one way to set it up and test it.

I was concerned about what would happen if there was a crash or power failure 
during the middle of the reshape, so I setup a test VM and simulated a power 
failure by stopping the VM. After it came back up, md continued the reshape 
right where it had left off, without missing a beat or any corruption. (I 
checked the corruption with a sha512 sum of the contents of the test 
filesystem on the raid device.)

To me, this is a killer feature of linux raid. ZFS certainly doesn't have it, 
and I doubt that any sub-$10k hardware raids do either. And even if cheap 
hardware raid cards did have it, they don't tend to have enough ports to make 
the feature all that useful. Whereas with software raid, you can almost always 
add another HBA to the box.

In fact, there is yet another cool feature of md: single-member raid60. That's 
a raid0 of a single raid6. Sounds silly, right? Well, then you can grow that 
raid0 online to 2, 3, or 10 members. You have to do --force the first time to 
set it up, because mdadm is justifiably surprised at a single-member raid0.

The downside is that other layers in the stack may not be so flexible. For 
example, with XFS you can optimize performance at the time you run mkfs.xfs by 
telling it the chunk size and stripe width parameters of the underlying raid 
device. For some workloads, it's better to set sunit/swidth to the individual 
raid6 members, for others (large sequential I/Os) it is better to set it to 
the raid0. In the latter case, reshaping the raid60 would result in the xfs no 
longer having optimal parameters. Maybe it would be nice if XFS had an online
"reshape" just like mdadm to be able to modify these parameters, but since
there isn't, I just went with the underlying raid6 params even though my
workload may have benefited from the other a little bit.

All that said, there may not be a significant performance difference between
raid60 and raid6+linear concat (e.g. via LVM) in the particular use case that 
Roy Sigurd Karlsbakk is working on. And linear concat is certainly simpler
and more widely used, so probably safer.

--
Daniel Browning
Kavod Technologies

# Note, this test uses /dev/loop8 through /dev/loop19.
# Most boxes only have loop0 through loop7.

mkdir -p tmp/raid-test
cd tmp/raid-test

dd if=/dev/zero of=test-p1c1.img bs=1M count=100 2> /dev/null
losetup /dev/loop8 test-p1c1.img
dd if=/dev/zero of=test-p1c2.img bs=1M count=100 2> /dev/null
losetup /dev/loop9 test-p1c2.img
dd if=/dev/zero of=test-p1c3.img bs=1M count=100 2> /dev/null
losetup /dev/loop10 test-p1c3.img
dd if=/dev/zero of=test-p1c4.img bs=1M count=100 2> /dev/null
losetup /dev/loop11 test-p1c4.img

mdadm --create --verbose /dev/md21 --level=6 --raid-devices=4 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11

dd if=/dev/zero of=test-p2c1.img bs=1M count=100 2> /dev/null
losetup /dev/loop12 test-p2c1.img
dd if=/dev/zero of=test-p2c2.img bs=1M count=100 2> /dev/null
losetup /dev/loop13 test-p2c2.img
dd if=/dev/zero of=test-p2c3.img bs=1M count=100 2> /dev/null
losetup /dev/loop14 test-p2c3.img
dd if=/dev/zero of=test-p2c4.img bs=1M count=100 2> /dev/null
losetup /dev/loop15 test-p2c4.img

mdadm --create --verbose /dev/md22 --level=6 --raid-devices=4 /dev/loop12 /dev/loop13 /dev/loop14 /dev/loop15

cat /proc/mdstat

dd if=/dev/zero of=test-p3c1.img bs=1M count=100 2> /dev/null
losetup /dev/loop16 test-p3c1.img
dd if=/dev/zero of=test-p3c2.img bs=1M count=100 2> /dev/null
losetup /dev/loop17 test-p3c2.img
dd if=/dev/zero of=test-p3c3.img bs=1M count=100 2> /dev/null
losetup /dev/loop18 test-p3c3.img
dd if=/dev/zero of=test-p3c4.img bs=1M count=100 2> /dev/null
losetup /dev/loop19 test-p3c4.img

mdadm --create --verbose /dev/md23 --level=6 --raid-devices=4 /dev/loop16 /dev/loop17 /dev/loop18 /dev/loop19

cat /proc/mdstat

mdadm --create --verbose /dev/md24 --level=0 --raid-devices=1 --force /dev/md21

mkfs.xfs /dev/md24
cat /proc/mdstat

mkdir test_mount/
mount /dev/md24 test_mount/
# populate with data to 95% or so.
dd if=/dev/urandom of=test_mount/test_file bs=1M count=385
sha256sum test_mount/test_file > test_mount/test_file.sha256sum

# Now grow to two:
mdadm --manage /dev/md24 --add /dev/md22
mdadm --grow /dev/md24 --raid-devices=2

# Or three.
mdadm --manage /dev/md24 --add /dev/md23
mdadm --grow /dev/md24 --raid-devices=3

# Cleanup
umount test_mount/
mdadm --stop /dev/md24
mdadm --stop /dev/md23
mdadm --stop /dev/md21
mdadm --stop /dev/md22
losetup -d /dev/loop8
losetup -d /dev/loop9
losetup -d /dev/loop10
losetup -d /dev/loop11
losetup -d /dev/loop12
losetup -d /dev/loop13
losetup -d /dev/loop14
losetup -d /dev/loop15
losetup -d /dev/loop16
losetup -d /dev/loop17
losetup -d /dev/loop18
losetup -d /dev/loop19
#rm -Rf ./tmp/raid-test
