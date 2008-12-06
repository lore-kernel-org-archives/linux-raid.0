From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: JFS + RAID issue?
Date: Sat, 6 Dec 2008 17:44:08 -0600
Message-ID: <cccedfc60812061544x3beb3e4fsfa4c58cf340c8fb7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm not quite sure whom to get ahold of here, but I just had to reboot
my server because it went off into never never land and never came
back. What did I do? I created a level1 raid out of two loopbacked
files on the same filesystem for testing purposes.

# $CWD is on a freshly-formatted JFS partition
for i in 1 2; do dd if=/dev/zero of=raid.${i} bs=1k seek=$( echo
1024*1024*20 | bc ) count=0 conv=sync; done
losetup /dev/loop4 $PWD/raid.1
losetup /dev/loop5 $PWD/raid.2
mdadm --create /dev/md99 --level=1 --bitmap=internal --raid-devices=2
/dev/loop4 --write-mostly /dev/loop5

Shortly after the above command, I saw /proc/mdstat rebuild speed drop
quite rapidly below 10MB/s and then the entire machine became
completely unresponsive. Oh, the disk was making plenty of noise but I
gave it 5 minutes and only the console responded, by echoing back my
characters.

Otherwise, even to magic sys-rq, it appeared completely unresponsive
although not "dead".
Any ideas?

I've tried the same using the *same* disk/partition but formatted
using ext3 and did not have the same issue.

openSUSE 11.0, fully up-to-date, kernel 2.6.25.18-0.2-default on x86_64.

I've generally had pretty good luck with ext3 and jfs over the years,
but increasingly I'm worried that jfs is no longer under development.
:-(

-- 
Jon
