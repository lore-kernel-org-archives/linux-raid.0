From: "Marc L. de Bruin" <marc@debruin.org>
Subject: Re: Can't get drives containing spare devices to spindown
Date: Thu, 22 Jun 2006 06:49:22 +0200
Message-ID: <449A2152.2040906@debruin.org>
References: <446395C0.5060502@debruin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <446395C0.5060502@debruin.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Marc L. de Bruin" <marc@debruin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marc L. de Bruin wrote:

> Situation: /dev/md0, type raid1, containing 2 active devices 
> (/dev/hda1 and /dev/hdc1) and 2 spare devices (/dev/hde1 and /dev/hdg1).
>
> Those two spare 'partitions' are the only partitions on those disks 
> and therefore I'd like to spin down those disks using hdparm for 
> obvious reasons (noise, heat). Specifically, 'hdparm -S <value> 
> <device>' sets the standby (spindown) timeout for a drive; the value 
> is used by the drive to determine how long to wait (with no disk 
> activity) before turning off the spindle motor to save power.
>
> However, it turns out that md actually sort-of prevents those spare 
> disks to spindown. I can get them off for about 3 to 4 seconds, after 
> which they immediately spin up again. Removing the spare devices from 
> /dev/md0 (mdadm /dev/md0 --remove /dev/hd[eg]1) actually solves this, 
> but I have no intention actually removing those devices.
>
> How can I make sure that I'm actually able to spin down those two 
> spare drives?

I'm replying to myself here which seems pointless, but AFAIK I got no 
reply and I still believe this is an interesting issue. :-)

Also, I have some extra info. After doing some research, it seems that 
the busy-ness of the filesystem matters too? For example, if I create a 
/dev/md1 on /dev/hdb1 and /dev/hdd1 with two spares on /dev/hdf1 and 
/dev/hdh1, put a filesystem on /dev/md1, mount it, put the spare drives 
to sleep (hdparm -S 5 /dev/hd[fh1]), and leave that filesystem alone 
completely, every few minutes for to me no obvious reason those spare 
drives will spin-up. I can only think of one reason: the md subsystem 
has to put some meta-info (hashes?) about /dev/md1 on the spare drives.

If I use the filesystem on /dev/md1 more intensively, those 'every few 
minutes' seems to become 'every 15 or so seconds'.

I may be completely wrong here (I'm no md guru), but maybe someone can 
confirm this behaviour? And if so, is there a way to control it? And if 
not, what could happen here?

For the original problem I can think of a solution: removing the spare 
drives from the array, get them to spin-down and use the mdadm monitor 
feature to trigger a script on a 'Failed' event which adds a spare to 
that array and remove any spin-down time from that spare. However, 
although this sort-of fixes the problem, there is still an extra short 
period of time where the raid1 array is not protected. If the scripts 
fails for whatever reason, the raid1 array might not be protected for a 
long time. Also, from an architectural point of view, this is really bad 
and should not be needed.

Thanks again for your time,

Marc.
