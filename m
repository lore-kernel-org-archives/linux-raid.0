From: Brian McKee <brian@soulspark.org>
Subject: Raid5 Array stopped suddenly, no apparent error messages.
Date: Wed, 09 May 2012 11:08:56 -0700
Message-ID: <4FAAB2B8.6090403@soulspark.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If this is not a good place to ask for help, please point me to where I
can ask. Sorry if I offend.

TL;DR: My question is this: is it safe to run mdadm --create
--assume-clean on an existing array? And by safe I mean: is it
guaranteed that the existing ext4 partition's data will not be lost when
I run the command?

Background: I have a 4.5TB Raid 5 Array (96% full) that has been up and
running for almost two years. A couple of months ago I upgraded my
kernel to 3.2.12 and yesterday around 2:00 PM this raid array stopped
working, became read only and started throwing a lot of I/O errors.

I assumed it was a failed drive but was saddened to see that according
to mdadm three drives had been removed from the array. The array
contains four drives, three 1.5 TB drives and one 2.0 TB drive
(partitioned so that it has a 1.5TB first partition to match the other
three). All three of the 1.5TB drives reported as bad according to mdadm.

I ran smartctl and it reported that all four drives were healthy which
gave me hope that something else had gone wrong and the data was okay.

For more details you can read this gentoo thread:
http://forums.gentoo.org/viewtopic-p-7033578.html

Summary: The three drives won't assemble because they are not fresh.

Any help or advice would be greatly appreciated. Mostly I want to know
if its safe to force mdadm to accept the drives into an array with
--create --assume-clean.

Thanks,

Brian McKee
