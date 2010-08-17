From: Joris <joris@v5.be>
Subject: reboot during reshape: superblock incorrect, cannot assemble
Date: Tue, 17 Aug 2010 22:10:26 +0200
Message-ID: <AANLkTikX5+MCicoYShS_=MqpuCr0CMgS1S2n97-k_Aoy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,


While expanding a raid6 array from 4 to 5 drives, I rebooted (got
impatient) at arround 9% done.
After this reboot I cannot re-assemble the array: "mdadm: superblock
on /dev/sde2 doesn't match others - assembly aborted".
It always complains about the superblock of the first member
specified, re-ordering or excluding members offers no avail.

According to mdadm's examine, everything except checksum appears
identical (magic, version, uuid, reshape pos, events).

Various people suggest wiping the superblocks and re-creating the
array. Is this the best option?
Will this work with an array that is being rebuild/reshaped? Anything
else I could od?



Somewhat related: my raid version on that array is now somehow
00.91.00, grub2 (at least the last release) verifies for 90 and will
refuse to install (even if grub does not use the array, it seems). I'm
just going to remove the check on the code and recompile.


Thanks in advance,
Joris
