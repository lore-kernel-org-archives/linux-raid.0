From: "David Rees" <dbr@greenhydrant.com>
Subject: Re: experiences with 3Ware 6400 3W-6400?
Date: Fri, 27 Jun 2003 11:23:40 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3841.208.48.139.163.1056738220.squirrel@www.greenhydrant.com>
References: <Pine.LNX.4.55.0306270920010.6883@datavibe.net>
     <Pine.LNX.4.43.0306271429480.32150-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.43.0306271429480.32150-100000@unicorn.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson said:
>
> Eg. the PC I'm currently typing this email on is 100 miles away and I
> don't particularly want to drive to it to fix it if a disk fails...
>
> gordon @ unicorn: df -h /
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md0              236M   20M  204M   9% /
>
> gordon @ unicorn: cat /proc/mdstat
> ...
> md0 : active raid1 hdc1[1] hda1[0]
>       249856 blocks [2/2] [UU]
> ...

So what do you do when /dev/hda fails and the computer won't reboot?  Have
you managed to get it to boot off /dev/hdc when /dev/hda isn't available?

Not having to worry about these sorts of things is one reason it's nice to
have hardware RAID for at least the boot device.

-Dave
