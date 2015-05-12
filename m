From: Another Sillyname <anothersname@googlemail.com>
Subject: Installing Linux directly onto RAID6 Array...........
Date: Tue, 12 May 2015 11:08:36 +0100
Message-ID: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've tried to do some research on this but the information out there
seems a bit contradictory (mainly because some is so old).

I want to install Fedora directly onto a RAID array (no separate boot disk).

My plan is to 'pre configure' the 6 drives as a clean RAID6 array,
effectively sd[a-f] without partitions and then attempt to install
Fedora 21, from sources it looks like Grub2 should recognise the array
and then allow the Kernel to boot thereby 'enabling' the array to
become visible and active.

However I have not been able to find an actual example of someone
trying this......thoughts?

The reason to do this is I'm intending to use a Mini ITX board with 6
sata ports and want to use 8TB drives in Raid6 to give me a very high
density data resilient small form factor storage box.

Ideas/Suggestions?

Thanks

Tony
