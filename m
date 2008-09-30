From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
Date: Tue, 30 Sep 2008 17:18:43 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0809301715280.14600@p34.internal.lan>
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>  <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>  <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>  <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>  <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>
  <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>  <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan>  <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>  <48DBAB81.8050900@tmr.com> <48E08E2D.6050905@kernel.org>
 <a52a95e30809301347s70b57ebfh280a6871329afd72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <a52a95e30809301347s70b57ebfh280a6871329afd72@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Mortensen <tmmlkml@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Bill Davidsen <davidsen@tmr.com>, Gwendal Grignou <gwendal@google.com>, Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Bruce Allen <ballen@gravity.phys.uwm.edu>
List-Id: linux-raid.ids



On Tue, 30 Sep 2008, Tom Mortensen wrote:

> Don't know if this is the original poster's problem, but if the drive
> is spun down, then enabling SMART or trying to read SMART attributes
> causes the drive to spin up and the command is delayed until this has
> occurred.
>
> The fix is to increase the timeout given to scsi_execute() in
> drivers/ata/libata-scsi.c.
>
> ie, current code (2.6.26.5) is:
>
>        /* Good values for timeout and retries?  Values below
>           from scsi_ioctl_send_command() for default case... */
>        cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
>                                  sensebuf, (10*HZ), 5, 0);
>
> Should be changed to:
>
>        /* Good values for timeout and retries?  Values below
>           from scsi_ioctl_send_command() for default case... */
>        cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
>                                  sensebuf, (30*HZ), 5, 0);
>
> Using a 1TB Hitachi hard drive, this command times out because it
> takes this drive about 15 seconds to spin up.  Virtutally all hard
> drives spin up in less than 30 sec, but perhaps make this higher in
> case there are slower drives out there?
>
> Cheers,
> Tom

Velociraptor 10k drive here (2.6.26.5):

Sep 30 15:55:06 p34 kernel: [420781.333179] ata6.00: exception Emask 0x0 SAct
0x0 SErr 0x0 action 0x6 frozen
Sep 30 15:55:06 p34 kernel: [420781.333189] ata6.00: cmd
b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
Sep 30 15:55:06 p34 kernel: [420781.333190]          res
40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Sep 30 15:55:06 p34 kernel: [420781.333194] ata6.00: status: { DRDY }
Sep 30 15:55:06 p34 kernel: [420781.333200] ata6: hard resetting link
Sep 30 15:55:06 p34 kernel: [420781.638589] ata6: SATA link up 3.0 Gbps (SStatus
123 SControl 300)
Sep 30 15:55:06 p34 kernel: [420781.662166] ata6.00: configured for UDMA/133
Sep 30 15:55:06 p34 kernel: [420781.669416] sd 5:0:0:0: [sdf] Write Protect is
off
Sep 30 15:55:06 p34 kernel: [420781.669416] sd 5:0:0:0: [sdf] Mode Sense: 00 3a
00 00
Sep 30 15:55:06 p34 kernel: [420781.669416] sd 5:0:0:0: [sdf] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA

Nothing wrong with the disk, it just happens... :(  Linux/kernel bug?
It happens on multiple controllers, Intel, SiI, Marvell, does not seem to
matter.

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA
_of_first_error
# 1  Short offline       Completed without error       00%      2761         -
# 2  Short offline       Completed without error       00%      2737         -
# 3  Extended offline    Completed without error       00%      2714         -
# 4  Short offline       Completed without error       00%      2689         -
# 5  Extended offline    Completed without error       00%      2514         -
# 6  Short offline       Completed without error       00%      2306         -
# 7  Short offline       Completed without error       00%      2282         -
# 8  Short offline       Completed without error       00%      2258         -
# 9  Short offline       Completed without error       00%      2234         -
#10  Extended offline    Completed without error       00%      2211         -
#11  Short offline       Completed without error       00%      2186         -
#12  Short offline       Completed without error       00%      2138         -
#13  Short offline       Completed without error       00%      2114         -
#14  Short offline       Completed without error       00%      2090         -
#15  Short offline       Completed without error       00%      2066         -
#16  Extended offline    Completed without error       00%      2043         -
#17  Short offline       Completed without error       00%      2018         -
#18  Short offline       Completed without error       00%      1970         -
#19  Short offline       Completed without error       00%      1947         -
#20  Short offline       Completed without error       00%      1923         -
#21  Short offline       Completed without error       00%      1899         -


Justin.

