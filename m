From: peter pilsl <pilsl@goldfisch.at>
Subject: raid1-diseaster on reboot: old version overwrites new version
Date: Sat, 02 Apr 2005 17:43:51 +0200
Message-ID: <424EBDB7.2000106@goldfisch.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Two days ago I had a severe servercrash due to raid-problems. The whole 
thing started with a (homemade) DOS-attack on the server. The server 
went to its knees and needed to be resetted. After the reboot the server 
was working fine and background-reconstruction of the mirrors started.
About 30 minutes later the first anomalies occured. Applications 
reported missing libraries, fs-errors (reiserfs) and so on.
It took a while until I reckognized what was going on:

the /-partition was on a raid1 - /dev/md2 - based on two disks : hda6+hdc6.

For some reason the raid seemed to be out of sync for over a year and 
hdc6 holded a old copy that was now successively overwriting hda6 and 
changing the content of / while the raid was running.
I booted with a live-cd to discover the hdc6 was the exact copy of 
spring 2004 (easily found out by content and timestamps of various files 
over the system) and hda6 was not mountable. I ran reiserfsck and had 
the tree rebuild on hda6, but it was too late. All current data was gone.

I had a backup and server is up again and my head is on my shoulders, 
but it leaves a lot of questions to me:

* how can the raid be out of sync. I monitor /proc/mdstat on a 
5-minute-interval and log the content to files. The output was 
definitely like:

md2 : active raid1 hdc6[0] hda6[1]
       5120000 blocks [2/2] [UU]

over the last year without a single exception. I just tested the entries 
in my watchdog and checked functionality of the watchdog by removing one 
disk. It definitely barks.

* how can in case of a unsynced raid the old version overwrite the new 
version. This is like a nightmare (and I remember having such thing before)

* What did I do wrong?

The only explantion to me is, that I had the wrong entry in my 
lilo.conf. I had root=/dev/hda6 there instead of root=/dev/md2
So maybe root was always mounted as /dev/hda6 and never as /dev/md2, 
which was started, but never had any data written to it. Is this a 
possible explanation?


kernel 2.4.24
raidtools-0.90

thnx for any advice,
peter







-- 
mag. peter pilsl
goldfisch.at
IT-management
tel +43 699 1 3574035
fax +43 699 4 3574035
pilsl@goldfisch.at
