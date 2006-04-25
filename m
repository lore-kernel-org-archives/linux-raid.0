From: "Colin McDonald" <ce.mcdonald@gmail.com>
Subject: Anyone with experience with Acronis TrueImage for Linux 9.1 and MD/Software RAID
Date: Mon, 24 Apr 2006 22:45:48 -0400
Message-ID: <bbfa52890604241945y57bef970p1453298e9a2e6768@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have used Acronis to create quick images of critical servers that
were using either hardware RAID or that had a single drive. It works
great and is probably one of the best imaging tools that I have seen
up until i tried to restore an image of md partitions on a RHEL 3 box.
I have two 250GB SATA drives configured with RAID personality.

Here is my RAIDTAB

raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda1
    raid-disk     0
    device          /dev/sdb1
    raid-disk     1
raiddev             /dev/md3
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda5
    raid-disk     0
    device          /dev/sdb5
    raid-disk     1
raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda2
    raid-disk     0
    device          /dev/sdb2
    raid-disk     1
raiddev             /dev/md2
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/sda3
    raid-disk     0
    device          /dev/sdb3
    raid-disk

I followed the somewhat flaky directions on restoring from their user
guide and I get bad magic on all superblocks for all devices.

I can boot into linux rescue and then mount the sda1 to a temp mnt
directory and then chroot with no problem. I didn't even have to
re-lilo the boot disk.

I get a kernel panic and can't find initrd which I assume is just due
to the fact that it can't find any active md devices and any valid md
devices.

I sent this to their support but they sent the famous.

"Dear Colin,

Please accept our apologies for the delay with the response.

We want to inform you that we are working on the issue you have
reported. We will contact you to either provide with a possible
solution or request for additional information.

--
You are welcome to submit your comments on Acronis Customer Service.
Your feedback is very important for us. You can send your comments to
feedback@acronis.com or fill the form at
https://www.acronis.com/enterprise/my/support/?ab=3."


Which means, I need to find a different path to backup-imaging goodness.


I get an invalid argument on all devices
md0=invalid arg
md1=invalid arg
md2=invalid arg
md3=invalid arg

I have exact or shall I say nearly identical hardware on a second
machine. Now I know I could take one of the drives in the original
machine and sync it to a new drive on the backup system but we think
one of those disks may be failing. One of the drives from the other
system (sdb) keeps failing partitions so I am very worried about using
that system to do this.

I figure that I could somehow run a new kernel image with
--omit-raid-modules and then change lilo to boot from the sda device
but does anyone from the list have any suggestions or has anyone
worked with Acronis and MD configurations to get the restoration
process to work properly.

I could have already bulit a completely new machine and manually
configured it and copied over /etc and other critical files, etc...but
it kind of defeats the purpose which is to give the IT department the
ability to bring a machine up within a couple of hours without much
linux admin experience.

Thanks and as always this list is one of the most edifying.

Colin

Colin E. McDonald, President
SquareWave, LLC
335 East 54th Street
Savannah, GA  31405
(912)313-2525
colin@swaveit.com
http://www.swaveit.com
