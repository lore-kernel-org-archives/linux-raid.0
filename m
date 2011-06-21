From: maurice <mhilarius@gmail.com>
Subject: Looking for the best way to do this
Date: Tue, 21 Jun 2011 12:13:05 -0600
Message-ID: <4E00DF31.2020406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good day, and thanks in advance for any ideas and advice.

I am working on a server.
The server is normally in a remote location, not outside accessible by 
network,
and there is no easy method to do backups on it.
It is running Fedora 14

It has 2 hard drives at present, and there are 5 partitions  on each.
 From this we have 3 RAID1 md devices.
These are for /boot, /data and /

I wish to add a 3rd disk, for enhancing the safety of the data.
There is no space to add a 4th disk.

Things I thought of doing include:
Add 3rd disk to make a 3 disk RAID1
Make a RAID10, missing one disk.

Which do you think is the better means to enhance data safety / chances 
of surviving a hardware problem?
One of the above, or an other configuration?

And, assuming I want to preserve the existing data, what is the best way 
to do this?


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
