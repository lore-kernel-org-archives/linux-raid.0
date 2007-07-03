From: Nix <nix@esperi.org.uk>
Subject: Re: spare not becoming active
Date: Tue, 03 Jul 2007 23:20:14 +0100
Message-ID: <87bqetjfj5.fsf@hades.wkstn.nix>
References: <4682C9ED.9040503@gmail.com> <4683DC71.3050200@gmail.com>
	<f7de5e030707031353o14c4a7bbjb2a270646f75fe54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f7de5e030707031353o14c4a7bbjb2a270646f75fe54@mail.gmail.com> (Simon's message of "3 Jul 2007 21:53:53 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Simon <simon.xhz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 Jul 2007, Simon spake thusly:
> I have 3 identical drives, fresh made, i issue the command:
> mdadm --create --verbose /dev/md1 --level=raid5 --raid-devices=3
> /dev/sdb2 /dev/sdc2 /dev/sdd2

OK...

> /dev/md1:
>        Version : 00.90.03
>  Creation Time : Tue Jul  3 16:29:38 2007
>     Raid Level : raid5
>     Array Size : 2011648 (1964.83 MiB 2059.93 MB)
>  Used Dev Size : 1005824 (982.41 MiB 1029.96 MB)
>   Raid Devices : 3
>  Total Devices : 3
> Preferred Minor : 1
>    Persistence : Superblock is persistent
>
>    Update Time : Tue Jul  3 16:31:05 2007
>          State : clean, degraded, recovering

OK...

> Active Devices : 2
> Working Devices : 3
> Failed Devices : 0
>  Spare Devices : 1
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
> Rebuild Status : 39% complete
>
>           UUID : 84aa4aaf:8b2c555e:3f9ae70d:2eedd5b3
>         Events : 0.4
>
>    Number   Major   Minor   RaidDevice State
>       0       8       18        0      active sync   /dev/sdb2
>       1       8       34        1      active sync   /dev/sdc2
>       3       8       50        2      spare rebuilding   /dev/sdd2

This is normal for a RAID-5 array construction. Rather than force you to
wait for ages until the RAID parity has been written, mdadm creates a
degraded two-element array with a single spare and fails over to it; the
rebuild involved in the failover automatically constructs the parity.

(Perhaps mdadm --detail could note that the first reconstruction hasn't
finished and tell the user what's going on.

Anyway, you're at 39%: wait, and eventually the reconstruction will be
done.  Obviously if you shut down before then it'll come up degraded an
you'll have to wait while it reconstructs again. So, um, don't do
that. :)

> ================================================================================
> [dev   9,   1] /dev/md1         84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 online
> [dev   8,  18] /dev/sdb2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 good
> [dev   8,  34] /dev/sdc2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 good
> [dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
> [dev   8,  50] /dev/sdd2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 spare

That output is rather strange though, mainly because of the mystic
missing drive with no name. mdadm bug?

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
