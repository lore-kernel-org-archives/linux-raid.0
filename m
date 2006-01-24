From: Francois Barre <francois.barre@gmail.com>
Subject: Raid5 degraded mode : what happens for real, and when resync will occur ?
Date: Tue, 24 Jan 2006 09:46:24 +0100
Message-ID: <fd8d0180601240046l1c516f68p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

Please forgive me for my early-morning wonderings, but I am planning
to make a non-raid -> raid5 migration in a way that could be summed up
like this :
Let sda5 be the originial partition. Let sd[bcd]5 be the additionnal
ones to build up the raid5.
After security backups and sd[bcd]5 partition creation, I would try and do :
Step 0 :
mdadm -l 5 -n 4 /dev/sd[bcd]5 missing
Step 1 :
(start the array as degraded)
Step 2 :
Format /dev/md0, copy sda5 contents to md0, re-create partitions on sda
Step 3 :
mdadm -a /dev/md0 /dev/sda5

At the end of Step 3, we have a working raid5 4-disk array, with the
contents of the previous sda5.
My questions are :
* When will the (real/final) resync occur ? I guess it's in step3,
because during all steps before, there is nothing to resync... Am I
right or wrong ?
* What happens for real during Step1/2 ? Id est for a given stripe,
will the parity block be computed and written as well ? Does a
degraded array work exactly as a normal one for blocks layout ? (I
can't help wondering, because IHMO, this is a terrific algorithmic
issue).

Well, having written down my questions I guess I have the answer, so
if you just can say 'yes little boy, you're right, md is good for
you', I would be pleased.
