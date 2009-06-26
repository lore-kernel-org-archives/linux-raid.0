From: Molinero <marianne@masu.dk>
Subject: device with newer data added as spare - data now gone?
Date: Fri, 26 Jun 2009 04:46:54 -0700 (PDT)
Message-ID: <24218843.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all

I've lost quite a lot of data on my /home raid partition and I'm wondering
what exactly I did to make it happen. I'd like to know so something similar
won't happen in the future.

I'm pretty much a raid newbie. I setup raid1 on my home server and I'm
guessing that something like this happened. Please tell me if it's possible.

* Some time ago I did something to have one device fail which resulted md3
in having only 1 device.
* Time went by without me noticing (because I suck)
* An update broke my raid setup and gave me a kernel panic (because I suck).
Didn't put the mdadm and raid hooks in mkinitcpio.conf
* Booted a live-cd, mounted the drives and chrooted back into the system and
fixed the mkinitcpio.conf
* Rebooted and noticed that md3 was running with only 1 device
* Added sdb4 to md3 and it then read 1 device with 1 spare
* cat /proc/mdstat started to say "recovery"
* All data from approx. 1 year is gone

I guessing that the old (not updated) device was set as "master" and the
data on the drive (containing newer data) was overwritten by data on the old
device - is this plausible?

If not what exactly did I do to delete all of the data? 

It's not the end of the world but it does suck a lot - especially some email
and pictures are gone that I will miss.

Any clarifications will be much appreciated.
-- 
View this message in context: http://www.nabble.com/device-with-newer-data-added-as-spare---data-now-gone--tp24218843p24218843.html
Sent from the linux-raid mailing list archive at Nabble.com.

