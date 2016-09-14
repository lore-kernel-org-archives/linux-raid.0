From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Wed, 14 Sep 2016 08:32:54 -0600
Message-ID: <CAJCQCtSTaByUR_2dnGrA0y0dtTaS_sweLKn19QD1=wv+2mnvHg@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
 <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com> <CAHscji1fgVrKwOwf+sCfOrg-MNz0MwRzXAJswKcP=vP2x0PVug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji1fgVrKwOwf+sCfOrg-MNz0MwRzXAJswKcP=vP2x0PVug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 14, 2016 at 4:36 AM, Daniel Sanabria <sanabria.d@gmail.com> wrote

> it didn't give me any indication that it was in no-act mode but I
> decided to carry on with the backup flag and got this:
>
> [root@lamachine ~]# wipefs -a -b /dev/sdc
>
> wipefs: invalid option -- 'b'

Huh, must be a bug. Works for me with util-linux-2.28.1-1.fc24.x86_64
and I also get files in the user home.

-rw-------. 1 root root     2 Sep 13 22:13 wipefs-sdb-0x000001fe.bak
-rw-------. 1 root root     8 Sep 13 22:13 wipefs-sdb-0x00000200.bak
-rw-------. 1 root root     8 Sep 13 22:13 wipefs-sdb-0x3ba7ffe00.bak

Those are backups for the PMBR, primary GPT and backup GPT.



> before proceeding with manually creating both partitions could you
> confirm the above is kind of expected?

I expected that it would find the GPT's also and erase their signature
and write out backup files. Oh well.



>> Chances are you could just use gdisk to verify and fix the primary and
>> backup GPTs on sdc and sde
>
> Will the fix be offered as part of the verify command in gdisk (command: v)?

It actually does the fix in memory as soon as you run the command, and
v just elaborates on any problems that don't make sense like
overlapping partitions etc.

So yes you can just run gdisk, go to expert menu with x, then verify
with v, and print the table with p, and post all of that and we'll
confirm before you use w to write out the fixed table.



>
>> When it's all done and working with the new MBR you can either leave
>> it alone, or you can run gdisk on it and it will immediately convert
>> it (in memory) and you can commit it to disk with the w command to go
>> back to GPT
>
> so just running the w command after running the verify command while
> on the same session ?

Yes but let's just skip the fdisk stuff. There is already a primary
and backup GPT, and  you even have a backup of the backup with the
good on on sdd that confirms all of the numbers. So, I think it's safe
to just move foward with the repair using gdisk. But post the verify,
and print command output first, before writing out the change.


-- 
Chris Murphy
