From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Re: [systemd-devel] Errorneous detection of degraded array
Date: Fri, 27 Jan 2017 10:12:22 +0300
Message-ID: <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
Sender: linux-raid-owner@vger.kernel.org
To: Luke Pyzowski <Luke@sunrisefutures.com>, "'systemd-devel@lists.freedesktop.org'" <systemd-devel@lists.freedesktop.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

26.01.2017 21:02, Luke Pyzowski пишет:
> Hello,
> I have a large RAID6 device with 24 local drives on CentOS7.3. Randomly (around 50% of the time) systemd will unmount my RAID device thinking it is degraded after the mdadm-last-resort@.timer expires, however the device is working normally by all accounts, and I can immediately mount it manually upon boot completion. In the logs below /share is the RAID device. I can increase the timer in /usr/lib/systemd/system/mdadm-last-resort@.timer from 30 to 60 seconds, but this problem can randomly still occur.
> 
> systemd[1]: Created slice system-mdadm\x2dlast\x2dresort.slice.
> systemd[1]: Starting system-mdadm\x2dlast\x2dresort.slice.
> systemd[1]: Starting Activate md array even though degraded...
> systemd[1]: Stopped target Local File Systems.
> systemd[1]: Stopping Local File Systems.
> systemd[1]: Unmounting /share...
> systemd[1]: Stopped (with error) /dev/md0.
> systemd[1]: Started Activate md array even though degraded.
> systemd[1]: Unmounted /share.
> 
> When the system boots normally the following is in the logs:
> systemd[1]: Started Timer to wait for more drives before activating degraded array..
> systemd[1]: Starting Timer to wait for more drives before activating degraded array..
> ...
> systemd[1]: Stopped Timer to wait for more drives before activating degraded array..
> systemd[1]: Stopping Timer to wait for more drives before activating degraded array..
> 
> The above occurs within the same second according to the timestamps and the timer ends prior to mounting any local filesystems, it properly detects that the RAID is valid and everything continues normally. The other RAID device - a RAID1 of 2 disks containing swap and / have never exhibited this failure.
> 
> My question is, what are the conditions where systemd detects the RAID6 as being degraded? It seems to be a race condition somewhere, but I am not sure what configuration should be modified if any. If needed I can provide more verbose logs, just let me know if they might be useful.
> 

It is not directly related to systemd. When block device that is part of
MD array is detected by kernel, udev rule queries array if it is
complete. If it is, it starts array (subject to general rules of which
arrays are auto-started); and if not, it (udev rule) starts timer to
assemble degraded array.

See udev-md-raid-assembly.rules in mdadm sources:

ACTION=="add|change", ENV{MD_STARTED}=="*unsafe*",
ENV{MD_FOREIGN}=="no",
ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"

So it looks like events for some array members either got lost or are
delivered late.

Note that there was discussion on openSUSE list where arrays would not
be auto-assembled on boot, even though triggering device change *after*
initial boot would correctly run these rules. This situation was
triggered by adding extra disk to the system (i.e. - boot with 3 disks
worked, with 4 disks - not). I could not find any hints even after
enabling full udev and systemd debug logs. Logs are available if anyone
wants to try it.
