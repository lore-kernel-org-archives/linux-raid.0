From: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>
Subject: Re: raid1+raid0 mdadm
Date: Sat, 15 Apr 2006 23:32:18 +0200
Message-ID: <44416662.9050601@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dariusz Malec wrote:
>
>    I can't configure mdadm. I have created 2 raid1 devices and i
> wanted to connect them with raid0. Everything is fine when i use
> command line, but after reboot mdadm starts only raid1 devices.

Not sure if by "mdadm starts only raid1 devices", you're actually 
referring to the output of "cat /proc/mdstat", or to the fact that the 
devices won't mount properly at boottime.

If the latter:  I used to have LABEL references in /etc/fstab, rather 
than actual device names, and that proved impracticable for raid1+0 devices.

Suppose you have two raid1 devices, md0 and md1, with which you create 
raid0 device md2.  You then create an ext2/3 filesystem on md3.
If you dump the header of md2 (# dumpe2fs -h /dev/md2), you will find 
the filesystem label you used when you created the filesystem.  When you 
dump the headers of md0 and md1, you will only see the label on one of 
these devices (as is to be expected give that they are members of the 
md3 *stripeset*).
When you mount using the label, chances are that it will try to mount 
md0 rather than md2.

Changing the LABEL references to actual device names (e.g. /dev/md2) 
solved the issue for me.

Kind regards,

Herta

Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm

