From: Norman Schmidt <schmidt@naa.net>
Subject: Re: split RAID1 during backups?
Date: Tue, 25 Oct 2005 21:20:41 +0200
Message-ID: <435E8589.9000303@naa.net>
References: <E1EUFcV-0005s3-00@toko.jab.org>	<435DEE69.8030605@naa.net> <17246.28805.267226.810872@smtp.charter.net>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17246.28805.267226.810872@smtp.charter.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel schrieb:
> Norman> What you should be able to do with software raid1 is the
> Norman> following: Stop the raid, mount both underlying devices
> Norman> instead of the raid device, but of course READ ONLY. Both
> Norman> contain the complete data and filesystem, and in addition to
> Norman> that the md superblock at the end. Both should be identical
> Norman> copies of that.  Thus, you do not have to resync
> Norman> afterwards. You then can backup the one disk while serving the
> Norman> web server from the other. When you are done, unmount,
> Norman> assemble the raid, mount it and go on.
> 
> Umm... so what you're proposing would mean that he would have to stop
> his application, make sure nothing is accessing that volume, and then
> restart the application?  
> 
> Somehow I don't see that happening.  
> 
> Why do you feel that you have to stop and umount the volume for the
> splitting off of a read-only mirror pair for backups?  
> 
> John

All this "pulling a disk" sounded to me like a resync, and with that 
much data and slow access this resync would take ages.

And as far as I remember, there was a suggestion with stopping or 
interrupting applications anyway, was there not? Unfortunately, I have 
thrown most of the posts away.

If you keep the volume running, ok - it should still work from the data 
integrity point of view. But if you keep using the data from a 
functional raid1 (/dev/md1 on /data), you cannot disentangle the access, 
since the raid1 will read from both mirrors. But what was desired was a 
faster backup and being able to continue serving the data.

If one disk (without the read-balancing of raid1) would provide enough 
treoughput for the webserver, one could even do the following:

mount /dev/md1 /writeaccess
mount -r /dev/hda /data
mount -r /dev/hdc /backup

So write from /weiteacces (mirrored to both drives) and read from one 
for the webserver (statically) and from the other one for the backup.

Could that work?

Norman.
-- 
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
+49 9131 852 7321       IT-Systembetreuer Physikalische Chemie
