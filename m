From: Arild Langseid <arild@langseid.no>
Subject: need help: corrupt files on one of my raids
Date: Tue, 10 Nov 2009 15:07:04 +0100
Message-ID: <4AF97388.5080907@langseid.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all!

I have a strange problem with corrupted files on my raid1 volume. (A 
raid5 volume on the same computer works just fine).

One of my raids (md1) is a raid1 with two 1TB sata drives.
I am running lvm on the raid and have two of the volumes on the raid are:
/dev/vg0sata/lv0_bilderArchive
/dev/vg0sata/lv0_bilderProjects
(For your info: "bilder" in Norwegian is "pictures" in english)

What I want:
I want to use the lv0_bilderArchive to store my pictures unmodified and 
lv0_bilderProjects to hold my edited pictures and projects.

My problem is:

My files are corrupted. Usually the files (crw/cr2/jpg) are stored ok, 
but is corrupted later when new files/directories is added to the 
volume. Sometimes the files are corrupted instantly at save-time.

I discovered this first when copying from my laptop to the server via 
samba. By testing I have found that this behavour also applies when I 
copy local on the server from raid5 (md0) to the faulty raid1(md1) with 
cp -a.

I have tested with both reiserfs and ext3 filesystem. The 
file-corruption happens on both reiserfs and ext3.

One of my test-procedures was as follows:
1. copied 21 pictures localy to the root of the lv0_bilderProjects 
volume. First 10 pictures, then 11 more by cp -a. All pictures survived 
and was stored non-corrupted.
2. Then I copied a whole directory-tree with cp -a to the 
lv0_bilderProjects volume. Many pictures was corrupted, a few stored ok. 
All small text-files with exif-info seems ok. All files on the 
volume-root copied in 1) is ok.
3. Then I copied one more directory-tree. All pictures seems ok. Mostly 
jpg this time.
4. Then I copied one more directory-tree, larger this time. Now the 
first 21 pictures in the volume-root is corrupted. All of them - and 
some of them in a way that my browser can't show them at all but shows 
an error-message.

I think by my test that the samba, network and type of filesystem is not 
the source to my problems.

I have the same problem on all lvm-volumes on the raid in question (md1).

What's common and what's different on my to raids:

differences on the two raid-systems:
md0 (working correct) is a raid5, three ide-disks, 200GB each.
md1 (corrupted files) is a raid1, two sata-disks, 1TB each.

common:
I use lvm on both raid-devices to host my filesystems.

other useful information:
I use Debian:
creator:~# cat /proc/version
Linux version 2.6.18-6-686 (Debian 2.6.18.dfsg.1-26etch1) 
(dannf@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian 
4.1.1-21)) #1 SMP Thu Nov 5 16:28:13 UTC 2009

I have run apt-get update and apt-get upgrade, and all seems to be updated.

The sata disks are hosted on the motherboard: ABit NF7
The disks hosting the raid I have trouble with (md1) are Hitachi
Deskstar 1TB 16MB SATA2 7200RPM, 0A38016

The output from mdadm --detail /dev/md1 and cat /proc/mdstat seems ok, 
but I can post the results here at request. The same applies to the 
output from pvdisplay, vgdisplay and lvdisplay. They seems ok, but I can 
post at request.

Due to the time to build a 1TB raid I have not tried to use the disks in 
md1 without raiding them. Is it a good idea to tear the raid down and 
test the disks directly or does any of you have other ideas to test 
before I take this time consuming action?


Any ideas out there? Links to information I should read?

Thank heaven for my backup-routines including all copy on cold
harddrives both in my safe and off location :-D

Thanks for all help!

Best Regards,
Arild, Oslo, Norway



