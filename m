From: Dan Graham <graham@molbio.uoregon.edu>
Subject: Converting Ext3 to Ext3 under RAID 1
Date: Wed, 2 Aug 2006 12:15:42 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0608021205110.626@molbio.uoregon.edu>
References: <200607152056.55090.pwaldo@waldoware.com> <200607230753.47853.pwaldo@waldoware.com>
 <17603.25777.274507.385333@cse.unsw.edu.au> <200607230832.48807.pwaldo@waldoware.com>
 <17605.22207.56022.972200@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17605.22207.56022.972200@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello;
   I have an existing, active ext3 filesystem which I would like to convert to
a RAID 1 ext3 filesystem with minimal down time.  After casting about the web 
and experimenting some on a test system, I believe that I can accomplish this 
in the following manner.

   - Dismount the filesystem.
   - Shrink the filesystem to leave room for the RAID superblock at the end
     while leaving the partition size untouched (shrinking by 16 blocks seems to
     work )
   - Create a degraded array with only the partition carrying the shrunk ext3
     system
   - start the array and mount the array.
   - hot add the mirroring partitions.

The questions I have for those who know Linux-Raid better than I.

    Is this scheme even half-way sane?
    Is 16 blocks a large enough area?


Thanks in advance for any and all feed-back.

-- 
Daniel Graham
graham@molbio.uoregon.edu

541-346-5079 (voice)
541-346-4854 (FAX)

Institute of Molecular Biology
1229 University of Oregon
Eugene, OR 97403-1229

