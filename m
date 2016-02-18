From: d c <c866e866e@gmail.com>
Subject: Re: More information on linux raid partition problem
Date: Thu, 18 Feb 2016 18:17:47 +0100
Message-ID: <CAM1AHSwBhjcaQ5dOfu7nfYQGtwQ0RGzGuFdo6ALB44aArGPLSQ@mail.gmail.com>
References: <CAM1AHSyqg=0JRt4Ju352foV2M9gjTHMW5y94Dfj-h+96mKT1Jg@mail.gmail.com>
	<56C5F6A4.4040205@digitallyhosted.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C5F6A4.4040205@digitallyhosted.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Admin@DH" <admin@digitallyhosted.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the reply.

Yes that was just a typo when I rerun the command for the e-mail.

Originally I typed it correct (and that does not work either)

     mdadm --assemble /dev/md0 /dev/sdd2 /dev/sde2
          mdadm: cannot open device /dev/sdd2: Device or resource busy
          mdadm: /dev/sdd2 has no superblock - assembly aborted

On Thu, Feb 18, 2016 at 5:51 PM, Admin@DH <admin@digitallyhosted.com> wrote:
> You typed:
>
> mdadm --assemble /dev/md0 /dev/hdd2 /dev/hde2
>
> It should be:
>
> mdadm --assemble /dev/md0 /dev/sdd2 /dev/sde2
>
> Was that just a typo?
>
>
> On 18/02/2016 16:12, d c wrote:
>
> For anyone who can help me here is some more information on my linux
> raid partition problem.
>
> As stated before, I only have two disks from a three disk raid 5.
>
> When I try:
>
>      mdadm --assemble /dev/md0 /dev/hdd2 /dev/hde2
>
> I get the following error:
>
>      mdadm: cannot open device /dev/hdd2: No such file or directory
>      mdadm: /dev/hdd2 has no superblock - assembly aborted
>
> When I do a mdadm examine, I get a different number of events:
>
>      mdadm --examine /dev/sdd2 | egrep Event
>           Events : 60541
>      mdadm --examine /dev/sde2 | egrep Event
>           Events : 60544
>
> Also mdadm examine gives different States:
>
>      mdadm --examine /dev/sdd2 | egrep State
>           State : active
>      mdadm --examine /dev/sde2 | egrep State
>           State : clean
>
> But mdadm shows that their Magic and UUID numbers are the same.
>
> Can anyone give suggestions on how I can repair this?
>
> Here are the full mdadm --examine outputs:
>
> mdadm --examine  /dev/sdd2
> /dev/sdd2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 1787919b:a8648f43:ae108b15:09b5fb69
>   Creation Time : Fri Jan  7 17:54:08 2005
>      Raid Level : raid5
>   Used Dev Size : 48194816 (45.96 GiB 49.35 GB)
>      Array Size : 96389632 (91.92 GiB 98.70 GB)
>    Raid Devices : 3
>   Total Devices : 2
> Preferred Minor : 126
>
>     Update Time : Tue May  1 15:55:58 2012
>           State : active
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : b53ef3cf - correct
>          Events : 60541
>
>          Layout : left-symmetric
>      Chunk Size : 128K
>
>       Number   Major   Minor   RaidDevice State
> this     2       8       66        2      active sync   /dev/sde2
>
>    0     0       0        0        0      removed
>    1     1       8       50        1      active sync   /dev/sdd2
>    2     2       8       66        2      active sync   /dev/sde2
>
> mdadm --examine  /dev/sde2
> /dev/sde2:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 1787919b:a8648f43:ae108b15:09b5fb69
>   Creation Time : Fri Jan  7 17:54:08 2005
>      Raid Level : raid5
>   Used Dev Size : 48194816 (45.96 GiB 49.35 GB)
>      Array Size : 96389632 (91.92 GiB 98.70 GB)
>    Raid Devices : 3
>   Total Devices : 2
> Preferred Minor : 126
>
>     Update Time : Tue May  1 15:56:20 2012
>           State : clean
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : b53fe060 - correct
>          Events : 60544
>
>          Layout : left-symmetric
>      Chunk Size : 128K
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       50        1      active sync   /dev/sdd2
>
>    0     0       0        0        0      removed
>    1     1       8       50        1      active sync   /dev/sdd2
>    2     2       0        0        2      faulty removed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>
