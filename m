From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Failed Growing RAID 5 to RAID 6
Date: Thu, 29 Apr 2010 02:45:07 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1004290242550.6768@uplift.swm.pp.se>
References: <m2h624e8eba1004281158jf7c8c943o90ad8f3ec3584d4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m2h624e8eba1004281158jf7c8c943o90ad8f3ec3584d4c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Knickerbocker <jeremy.knickerbocker@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Apr 2010, Jeremy Knickerbocker wrote:

> jaykae-serv:~# mdadm --grow /dev/md1 --level=6 --raid-disk=8
> mdadm level of /dev/md1 changed to raid6
> mdadm: Need to backup 1501199875784021K of critical section..
> mdadm: /dev/md1: Something wrong - reshape aborted
> mdadm: aborting level change

What kernel are you running? If less than 2.6.32, it won't support this.

Do you have bitmap enabled? (I don't know how that shows up in the output 
you provided, please "cat /proc/mdstat" as well). If you have bitmap 
enabled, please remove it first.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
