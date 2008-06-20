From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: External bitmap disappears
Date: Fri, 20 Jun 2008 17:45:34 +0400
Message-ID: <485BB47E.8030804@msgid.tls.msk.ru>
References: <cccedfc60806200617k37498d4y1f01072145271d00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60806200617k37498d4y1f01072145271d00@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
> I've configured a raid10,f2 with an external bitmap:
> 
> mdadm --grow --bitmap=/md0.bitmap /dev/md0
> 
> The root ('/') filesystem is NOT on the raid. It's a normal partition
> (/dev/sdb1, the boot device actually).
> After reboot, cat /proc/mdstat does not show a bitmap. What's up with
> that? That sure doesn't seem right.

If a bitmap isn't stored inside a superblock, you have to
specify the same filename when ASSEMBLING the array.

Add it to mdadm.conf file.

/mjt

