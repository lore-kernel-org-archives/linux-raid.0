From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: Raid 5 array down/missing - went through wiki steps
Date: Sat, 28 Oct 2017 11:36:43 -0700
Message-ID: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Hope this email is going to the right place.

I'll cut to the chase - I added a drive to my RAID 5 and was resyncing
when my machine was abruptly powered down. Upon booting it up again,
my RAID array is now missing.

I've followed the instructions that I've found on the wiki, and it
hasn't solved my issues, but it's given me a sense of the things that
I'm hoping can help you guys help me troubleshoot.

My array can't be assembled. It tells me that the superblock on
/dev/sda doesn't match the others.

/dev/sda thinks the array has 7 drives
/dev/sd[bcefghi] thinks the array has 8 drives

/dev/sda was not being reshaped
/dev/sd[bcefghi] has reshape position data in the raid.status file

both /dev/sda and /dev/sdh think their device role is Active device 2

I can't bring /dev/md126 back up with sd[bcefghi] as it'll tell me
that there are 6 drives and 1 rebuilding, not enough to start the
array

My mdadm.conf shows a /dev/dev/127 with very minimal info in it - does
not look right to me.

I haven't zeroed the superblock, nor have I tried a clean-assemble
either. I saw the wiki say I should email the group if I've gotten
that far and I'm panicking and nothing's working. So...

Help me out, pretty please?
