From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: device with newer data added as spare - data now gone?
Date: Tue, 30 Jun 2009 21:43:32 -0500
Message-ID: <4A4ACD54.9030700@gmail.com>
References: <24218843.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24218843.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molinero <marianne@masu.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molinero wrote:
> Hi all
> 
> I've lost quite a lot of data on my /home raid partition and I'm wondering
> what exactly I did to make it happen. I'd like to know so something similar
> won't happen in the future.
> 
> I'm pretty much a raid newbie. I setup raid1 on my home server and I'm
> guessing that something like this happened. Please tell me if it's possible.
> 
> * Some time ago I did something to have one device fail which resulted md3
> in having only 1 device.
> * Time went by without me noticing (because I suck)
> * An update broke my raid setup and gave me a kernel panic (because I suck).
> Didn't put the mdadm and raid hooks in mkinitcpio.conf
> * Booted a live-cd, mounted the drives and chrooted back into the system and
> fixed the mkinitcpio.conf
> * Rebooted and noticed that md3 was running with only 1 device
> * Added sdb4 to md3 and it then read 1 device with 1 spare
> * cat /proc/mdstat started to say "recovery"
> * All data from approx. 1 year is gone
> 
> I guessing that the old (not updated) device was set as "master" and the
> data on the drive (containing newer data) was overwritten by data on the old
> device - is this plausible?

If the old device was brought up as md3 and had dropped out months 
ago, the data would now be the data that existed when that disk 
dropped off.   And when a device drops out, there is no mark on that 
device marking it as bad since the typical reasons for the device 
dropping off are that it is not longer talking.    And sometimes 
mirrors are intentionally broken for various reasons to preserve a 
copy for one reason or another such as to be able to back out of a 
serious OS upgrade that did not go well quickly.

If you added the current device as a spare it would have copied the 
data from the old device over the current device.

That is one thing that would make 3+ disk raid5 a bit more resistant 
to this, with a dropped off disk you could not start the array with 
only the dropped device, and with all 3, 2 of the devices will know 
the 3rd was dropped at some time in the past, and with any 2 on of 
those devices would believe the other one was marked bad.


