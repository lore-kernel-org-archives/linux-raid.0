From: Twigathy <twigathy@gmail.com>
Subject: Raid5 grow interrupted, failed
Date: Thu, 1 May 2008 21:06:12 +0100
Message-ID: <1f0f1a960805011306w3bba20bag343482a71110b33a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm in a bit of a fix here - I was expanding an mdadm raid5 array from
5 to 6 disks. During the expand, I had to shut down the machine to do
some fiddling about with its guts, retiring an old 4x200GB raid5
actually.

When I booted the machine back up again the array did not recover and
carry on reshaping. I tried various different tricks to see if I could
force-mount it, and I fear I may have wiped the array for good here...

The position I'm in now:
md5 is (was?) a 6x600GB raid5, being expanded from 5 disks to 6.
The UUIDs on 5 of the disks match up
The UUID on the other disk is different (uhoh)
The disk with a different UUID has this info in --examine:
  Reshape pos'n : 443168960 (422.64 GiB 453.81 GB)
  Delta Devices : 1 (5->6)
so mdadm has been recording where the reshape got to...

The other disks in the array do *not* have this reshape info in
them...I think this is probably because I force-assembled  somewhere
down the line and screwed things up a bit.

I can mount the 5-disk broken array and see about 1/4 of my data -
consistent with how far the reshape got before I shut down the
machine.

What I would like to do is to assemble the array and continue
reshaping where it left off - at that 422.64GiB point. Where do I
start? Can I even do this? Is my data gone for good? :-(

Thanks

Tom C
