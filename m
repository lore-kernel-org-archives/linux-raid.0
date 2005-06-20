From: "Nagpure, Dinesh" <Dinesh.Nagpure@stratus.com>
Subject: RE: md multipath restart problem
Date: Mon, 20 Jun 2005 12:01:39 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF4376EE2F3@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: John Madden <jmadden@ivytech.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John,

I encountered the bug using RHEL 4, fixed it and then found it already fixed in  linux-2.6.12-rc2.
The bug is in the function super_90_load() in md.c where it checks sb->level against MULTIPATH which should be LEVEL_MULTIPATH as below:

        rdev->preferred_minor = sb->md_minor;
        rdev->data_offset = 0;

        if (sb->level == LEVEL_MULTIPATH) /* THIS IS THE FIX - dinesh*/
                rdev->desc_nr = -1;
        else
                rdev->desc_nr = sb->this_disk.number;

        if (refdev == 0)
                ret = 1;

BTW what version of mdadm are you using? just curious, can you fail and then re-insert a path to a multipath array and then dump the superblock information using mdadm to see both the paths active again? I think paths get activated but the superblock is not updated so the information mdadm dumps is sort of incorrect.

-dinesh



 

-----Original Message-----
From: John Madden [mailto:jmadden@ivytech.edu]
Sent: Monday, June 20, 2005 10:42 AM
To: Nagpure, Dinesh
Cc: linux-raid@vger.kernel.org; Nagpure, Dinesh
Subject: RE: md multipath restart problem


> Have you found a solution to the problem? If not then which kernel version are you
> using. The problem you are talking about seems like a bug in md that got fixed
> recently.

And to think I was just about to give up and unsubscribe... :)

I did actually manage to fix the issue by just not doing things correctly -- if I
--build the array instead of starting it with -A, it works.  (See my previous
posts.) I'm running kernel 2.6.11.8 so far, what version has a/the fix?

Thanks,
  John




-- 
John Madden
UNIX Systems Engineer
Ivy Tech Community College of Indiana
jmadden@ivytech.edu

