From: Mike Hartman <mike@hartmanipulation.com>
Subject: New RAID causing system lockups
Date: Sat, 11 Sep 2010 14:13:00 -0400
Message-ID: <AANLkTiksA-BhShTwPzRvjJPPfg04HGrdvnZymnW+zQ2G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

PART 2:

Eventually I realized that while I couldn't do anything with bash, I
could run (some) commands directly via ssh (ssh odin <command>) and
they would work ok. I was able to run dmesg, cat some files. Was able
to ls some directories for a while, but eventually couldn't anymore.
Was NOT able to cat /proc/mdstat. It would just hang. Attached
(dmesg_1.txt) is the dmesg output I got, which seems to include
everything from the start of the reshaping up to the lockup. The RAID
system definitely seems to be involved.

After waiting a day or so with no change and nothing else working I
gritted my teeth and did a hard reboot, hoping my array wasn't totally
hosed. Fortunately, I was able to reassemble the array using the
backup file specified as part of my conversion command and the
reshaping picked back up where it left off. It completed without
further incident (took about 4 days).

Once the reshaping was complete I ran fsck on its filesystem (came
back clean even when forced), mounted it, and everything looked ok. No
files appeared to be lost. Chalking the freeze up to a one-time
problem related to the reshaping, I started copying all the data from
one of the other 1.5TB drives into the md0. (The idea is to keep
copying each drive's contents into the array, wiping it, adding it as
a hot spare, and then growing the RAID and its filesystem
accordingly.)

When I'm almost done (the 1.5TB only has 55GB left on it) the system
hangs again. Same symptoms as before. I was able to run dmesg again
(dmesg_2.txt) and the call trace looks pretty similar. It still
mentions the RAID system a good bit, even though no high level RAID
operations were going on and I was just writing to the array. This
time I only waited an hour or two before giving up and opting for the
hard reboot. Once again the array seemed to be ok once it was brought
back up.

Seems to be a fairly fundamental problem, whatever it is, and anything
that causes a lockup like this is a pretty big bug in a stable kernel.
The individual drives test out fine with everything I've tried.
Everything looks completely healthy until these lockups occur. I've
attached my lspci and kernel config in case there's something useful
in there.

Any ideas?

Mike
