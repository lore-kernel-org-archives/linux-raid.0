From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Sat, 30 Jan 2010 11:55:18 +0100
Message-ID: <4B641016.9080300@texsoft.it>
References: <4B5F6C73.30707@texsoft.it>	<20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129214852.00e565c4@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here are the lines I added to my drivers/md/md.c , function md_seq_show, 
to let /proc/mdstat show read errors on devices, if any:

    } else if (rdev->raid_disk < 0)
        seq_printf(seq, "(S)"); /* spare */

+  if (atomic_read(&rdev->read_errors) ||
+      atomic_read(&rdev->corrected_errors) )
+        seq_printf(seq, "(R:%u:%u)",
+            (unsigned int) atomic_read(&rdev->read_errors),
+            (unsigned int) atomic_read(&rdev->corrected_errors));

        sectors += rdev->sectors;
    }


Into md.h i see:

atomic_t  read_errors;   
/* number of consecutive read errors that we have tried to ignore. */
atomic_t corrected_errors;
/* number of corrected read errors, for reporting to userspace and 
storing in superblock. */

Ok for the second.. but I'm not sure about the meaning of the first 
one... and seems it's not reported by /sys/block/mdXX/dev-YY .. can it 
just be ignored?

Sample output:

md0 : active raid5 sdb1[1](R:0:36) sda1[0] sdc1[2]
      4192768 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

Regards
Giovanni

-- 
Yours faithfully.

Giovanni Tessore


