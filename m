From: Ron Leach <ronleach@tesco.net>
Subject: Re: SOLVED Booting after Debian upgrade: /dev/md5 does not exist
Date: Tue, 22 Jul 2014 17:30:44 +0100
Message-ID: <53CE91B4.7060209@tesco.net>
References: <53CE1C39.3070000@tesco.net> <53CE592B.6030706@turmel.org> <53CE654E.2000800@tesco.net> <53CE7E70.2000800@turmel.org> <53CE89E1.10109@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CE89E1.10109@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil, following all your advice, the server's mounts are coming up, 
RAID1 is synchronised, and /home is usable (and used); the machine is 
working.

While updating the initramfs, the update routine logged:

mdadm: /dev/md5 - no such device
(or something similar, I've lost the screen since a reboot)

I reverted to referring to the array as /dev/md126, in both 
mdadm.conf, and in fstab, and the initramfs update complained about 
that, as well.  So I left it as that, and rebooted.

Reboot was perfect.  Now all the /mdXs are up, with one labelled as 
/dev/md126, but that's ok, it's the same in the .conf file as in 
fstab.  The fstab had a number of redundant entries from periods when 
there were other discs also in the machine, so I cleaned those up, as 
well.

On, now, with the rest of the Debian upgrade.  Again, very many thanks 
for your help and patience.

regards, Ron
