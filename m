From: John Rowe <rowe@excc.ex.ac.uk>
Subject: Two-disk RAID5?
Date: Wed, 26 Apr 2006 17:41:47 +0100
Message-ID: <1146069707.10253.50.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm about to create a RAID1 file system and a strange thought occurs to
me: if I create a two-disk RAID5 array then I can grow it later by the
simple expedient of adding a third disk and hence doubling its size.

Is there any real down-side to this, such as performance? Alternatively
is it likely that mdadm will soon be able to convert a RAID1 pair to
RAID5 any time soon? (Just how different are they anyway? Isn't the
RAID4/5 checksum just an OR?)

Thanks

John


