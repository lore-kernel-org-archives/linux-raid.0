From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: want_replacement (aka --replace)
Date: Fri, 26 Apr 2013 20:18:40 -0700
Message-ID: <glsr4axsi2.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

For other reasons I moved one of my md servers to kernel 3.8, and on a
whim I decided to test --replace on a RAID6 array.  For this test I used
mdadm from Neil's git repository, but from a read of the md kernel
documentation you could probably do this just from manipulating
/sys/block/mdN/md/ appropriately if you don't or can't get the latest
mdadm.

It went very smoothly in my test.  I marked one drive with --replace,
and the array started rebuilding with the new drive, without any IO from
the other members of the array.  It took much less time than a full
rebuild, and when it was done, the old drive was marked faulty, as
expected.

This is really an amazing feature!  I can see at least two use cases for
it:

==you suspect a drive is failing but it hasn't been kicked yet
==you want to replace all the drives with larger drives in order to grow
the array

Are there any other use cases?  In the scenario where the drive marked
as wanting replacement fails completely, does md fall back to a full
rebuild with the new drive?  Can it pick up in the middle or does it
have to start over?

Thanks to Neil and the other md developers for such a great feature.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


