From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID Stopped Working With Aurora Kernel
Date: Tue, 21 May 2002 22:10:09 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15594.14625.624567.495812@notabene.cse.unsw.edu.au>
References: <CPEAKNIMKMJOCFPEOBGACECFCFAA.cwebster@ec.rr.com>
	<15592.56683.75251.569129@notabene.cse.unsw.edu.au>
	<3CEA2E81.F08127AF@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Calvin D. Webster on Tuesday May 21
To: cwebster@ec.rr.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday May 21, cwebster@ec.rr.com wrote:
> 
> This looks much better, but not just right. I would expect that the list
> following "Chunk Size" would be close to the /etc/raidtab that was being
> used prior to the Aurora upgrade when it was last working. At any rate,
> the "this" device and the last device listed are definitely not correct.
> I'm not sure what "this" should be, but I assume it should list
> parameters for the device being queried. 

Thanks for the detail.  I see my mistake.
Please apply this patch and try again.. (memcpy counts in words, even
when I give it pointers to __u32's (ofcourse!)).

NeilBrown

--- Examine.c	2002/05/21 12:07:44	1.1
+++ Examine.c	2002/05/21 12:08:01
@@ -170,7 +170,7 @@
 				__u32 *sb32 = (__u32*)&super;
 				memcpy(sb32+MD_SB_GENERIC_CONSTANT_WORDS+7,
 				       sb32+MD_SB_GENERIC_CONSTANT_WORDS+7+1,
-				       MD_SB_WORDS - (MD_SB_GENERIC_CONSTANT_WORDS+7+1));
+				       (MD_SB_WORDS - (MD_SB_GENERIC_CONSTANT_WORDS+7+1))*4);
 				printf (" --- adjusting superblock for 2.2/sparc compatability ---\n");
 			}
 			printf("         Events : %d.%d\n", super.events_hi, super.events_lo);
