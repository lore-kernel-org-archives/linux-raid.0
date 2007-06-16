From: Brad Campbell <brad@wasp.net.au>
Subject: Machine hanging on synchronize cache on shutdown 2.6.22-rc4-git[45678]
Date: Sat, 16 Jun 2007 15:52:33 +0400
Message-ID: <4673CF01.6010402@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

I've got a box here based on current Debian Stable.
It's got 15 Maxtor SATA drives in it on 4 Promise TX4 controllers.

Using kernel 2.6.21.x it shuts down, but of course with a huge "clack" as 15 drives all do emergency 
head parks simultaneously. I thought I'd upgrade to 2.6.22-rc to get around this but the machine 
just hangs up hard apparently trying to sync cache on a drive.

I've run this process manually, so I know it is being performed properly.

Prior to shutdown, all nfsd processes are stopped, filesystems unmounted and md arrays stopped.
/proc/mdstat shows
root@storage1:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
unused devices: <none>
root@storage1:~#

Here is the final hangup.

http://www.fnarfbargle.com/CIMG1029.JPG

They keyboard is responsive up until the "hard resetting port" when it just locks solid and requires 
a power-cycle.

It's not really something I want to bisect if I can avoid it give the lovely noise it makes when I 
power it off. (this box only has a hard power switch, no reset or soft power buttons)

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
