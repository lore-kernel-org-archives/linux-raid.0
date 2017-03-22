From: "John Stoffel" <john@stoffel.org>
Subject: Re: proactive disk replacement
Date: Wed, 22 Mar 2017 10:51:09 -0400
Message-ID: <22738.36701.470391.167986@quad.stoffel.home>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Allison <jeff.allison@allygray.2y.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Jeff> Hi all I’ve had a poke around but am yet to find something
Jeff> definitive.  I have a raid 5 array of 4 disks amounting to
Jeff> approx 5.5tb. Now this disks are getting a bit long in the tooth
Jeff> so before I get into problems I’ve bought 4 new disks to replace
Jeff> them.

Can I suggest that you buy another disk and convert into a RAID6 setup
for even more resiliency?  Esp with that much data (great that you
have backups!) the piece of mind of an extra disk is well worth the
cost in my mind.

Personally, I just go with RAID1 mirrors on large disks like this for
my home system.  I don't have *that* much stuff... though my disks too
are getting long in tooth.  

Jeff> I have a backup so if it all goes west I’m covered. So I’m
Jeff> looking for suggestions.

Jeff> My current plan is just to replace the 2tb drives with the new
Jeff> 3tb drives and move on, I’d like to do it on line with out
Jeff> having to trash the array and start again, so does anyone have a
Jeff> game plan for doing that.

You don't say how your system is setup, whether or not you have LVM on
top of the MD RAID5 array or not.  If you, you could simply do:

1. Build a new RAID6 array with five disks (buying another one like I
   suggest above).

2. Add this into your VG with the 4x2tb disks.

3. pvmove all your data onto the new PVs:

   pvmove -b <VG> <old-raid5-PV>

And once it's done, you can them remove that PV from the VG and pull
them from the system.  Or turn them into a scratch space until they
die...

Jeff> Or is a 9tb raid 5 array the wrong thing to be doing and should
Jeff> I be doing something else 6tb raid 10 or something I’m open to
Jeff> suggestions.

Depends on how good your backups are and how critical it is that this
data stay online.

John
