From: Pierre Wieser <pwieser@trychlos.org>
Subject: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Mon, 8 Jun 2015 21:28:43 +0200 (CEST)
Message-ID: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
References: <1419435054.589.1433790714774.JavaMail.zimbra@wieser.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1419435054.589.1433790714774.JavaMail.zimbra@wieser.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I currently have an almost full RAID 5 built with 4 x 2 TB disks.
I wonder if it would be possible to migrate it to a bigger RAID 5
with 3 x 6TB new disks.

I've imagined something like that :
- successively fail, remove a 2TB disk, add a 4TB disk, wait for end of recovery on three 2TB disks
- at the end of this first phase, I have the same ~6TB RAID 5 clean group with 3 x 4TB + 1 x 2TB disks
- declare the last 2 TB disk faulty and remove it
- the RAID 5 group state goes to clean, degraded
- grow the RAID 5 group with --size=max option
- grow the RAID 5 group with --array-size=~12TB option
- last, grow the RAID 5 group with --raid-devices=3 and --backup-file=... options.

And I have tested it on a small test RAID 5 group.
As expected, this last command makes the RAID 5 group begins a reshaping operation.
But this one keeps stucked at zero.

So I have several questions :

- is it even theorically possible to grow a RAID 5 while decreasing the number of disks ?
- do you think the sequence i've imagined is correct ?
- why the reshaping operation does it stuck at zero ?

Any help or hint would be greatly appreciated :)
Thanks
Regards
Pierre
