From: "Brett L. Trotter" <brett@silcon.com>
Subject: the true behavior of mdadm's raid-1 with regard to vertical parity
 and silent error detection/scrubbing- confirmation or feature request
Date: Tue, 17 Aug 2010 22:56:38 -0500
Message-ID: <4C6B59F6.5020001@silcon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've googled endlessly about the internal nature of a md Raid-1.

Over the years, I've found several single bit flips on traditional
platter disks on files that were previously on a linux raid-1 that had
split and while doing a verification of the two copies. This seems to
imply that what I'm looking for doesn't exist- and that is simply a
vertical parity within each disk at the md level- even a single crc32
every once in a while so that if a bit flips on drive 1 of a mirror,
drive 2's copy replaces it instead of 1's bit flipped copy replacing
drive 2's good copy. From what I can gather, it seems to be a 50/50 shot
whether your good copy gets mangled in the event of a silent bit flippage.

So- is there any built in parity that helps mdadm decide which copy to
use when the copies disagree on a raid 1 mirror during a resync?

If not- is there a reason why not beyond the extra space overhead and
read compute write overhead?

This issue interests me more as I look into SSDs and having flash blocks
wear out.


I'd choose a higher raid level if i could, but this is only a very small
atom 330 box with only mildly important data. I think I'm ultimately
looking for something like ZFS has, but ZFS under RHEL/CentOS will
probably never happen in any meaningful production worthy way due
licensing and the ultimate demise of sun and tainting of things that is
Oracle.

I'd love any information anyone has on the subject.

-Brett
