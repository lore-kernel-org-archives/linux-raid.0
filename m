From: Tyler <pml@dtbb.net>
Subject: Re: BUGREPORT: mdadm v2.0-devel - can't create array using version
 1 superblock, possibly related to previous bugreport
Date: Wed, 04 May 2005 05:13:48 -0700
Message-ID: <4278BC7C.5060705@dtbb.net>
References: <42775D47.4000805@dtbb.net>	<17016.3902.917012.297224@cse.unsw.edu.au>	<4278271B.1020408@dtbb.net>	<17016.12489.9021.728737@cse.unsw.edu.au>	<427858EB.4070501@dtbb.net> <17016.25780.914854.293277@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17016.25780.914854.293277@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

The last two patches got me going, however, I tried raid5 for the heck 
of it (I was just using it for testing earlier, and figured I would get 
the lesser of two evils working, then go for raid6), and it creates the 
array fine, and I can make a filesystem on it, and I can mount it, but, 
it is listed as clean, degraded in mdadm -D /dev/md0, and cat 
/proc/mdstat doesn't show any rebuilding/resyncing going on.  It doesn't 
seem to start the resync, never gaining redundancy.  Raid6 seems to be 
working just fine, thanks :).  Possibly another patch needed for raid5 
still.  Also, is there going to be more detail available about the array 
like there was with older mdadm tools?  Right now when you do a -D 
/dev/mdX, with a version one superblock, there doesn't seem to be much 
information regarding what drives are in the array, etc.   I also posted 
a bug a few days ago regarding mdadm v1.9.0 (or maybe 1.11 .. i forget 
if i tried it also), where if you have a large number of drives (I 
tested with 27), that the bottom of the -D /dev/mdX page seemed to be 
cut off, and didn't show things like spares, and removed drive, etc.

Currently I'm using a 2.6.11.8 vanilla kernel (md v0.90.01), I did *not* 
change "pad1[128-96]" to "pad1[128-100]", since 2.6.11.8 vanilla doesn't 
have the bitmap_offset added yet, I did patch super1.c to include the 
"info->layout" near line 400 (this patch was also present in one of your 
other patches), I also patched it with the one patch that came out on 
your web page after 2.0-devel was released (bitmap for v0.90.0 
superblock I believe), and patched with the raid5 superblock version 1 
support patch, the "disk busy" patch, and the greater than 27 MD 
superblock devices patch.  I think thats it :)

Not that it should matter, but i did it in this order:
patch.greater.than.27.superblock.devices (this patch includes change to 
super1.c near line 400, info->layout)
patch.raid5.to.support.superblock.version.1
patch.bitmap.support.for.v0.90.0.superblocks
patch.disk.busy

I ran a diff against it with the above patches, and have posted it at 
http://www.dtbb.net/~tyler/linux.troubleshoot/

I almost forgot to mention that one of the patches against Grow.c failed 
(I'm maybe missing another patch against Grow that you've done? Mine 
only has 194 lines):

root@localhost:~/dev/mdadm-2.0-devel-1# cat Grow.c.rej
***************
*** 236,242 ****
        }
        if (strcmp(file, "internal") == 0) {
                int d;
-               for (d=0; d< MD_SB_DISKS; d++) {
                        mdu_disk_info_t disk;
                        char *dv;
                        disk.number = d;
--- 236,242 ----
        }
        if (strcmp(file, "internal") == 0) {
                int d;
+               for (d=0; d< st->max_devs; d++) {
                        mdu_disk_info_t disk;
                        char *dv;
                        disk.number = d;

Regards,
Tyler.

Neil Brown wrote:

>On Tuesday May 3, pml@dtbb.net wrote:
>  
>
>>What kernel are you using Neil, and what patches to the kernel if any, 
>>and which patches to mdadm 2.0-devel?  
>>    
>>
>
>2.6.12-rc2-mm1  and a few patches to mdadm, but none significant to
>your current issue.
>
>The reason it worked for me is that I tried raid6 and you tried raid5.
>To make it work with raid5 you need the following patch.  I haven't
>actually tested it as my test machine has had odd hardware issues for
>ages (only causing problems at reboot, but for a test machine, that is
>often..) and it is finally being looked at.
>
>Let me know if this gets you further.
>
>NeilBrown
>
>
> ----------- Diffstat output ------------
> ./super1.c |    2 +-
> 1 files changed, 1 insertion(+), 1 deletion(-)
>
>diff ./super1.c~current~ ./super1.c
>--- ./super1.c~current~	2005-05-04 12:06:33.000000000 +1000
>+++ ./super1.c	2005-05-04 15:54:59.000000000 +1000
>@@ -411,7 +411,7 @@ static int init_super1(void **sbp, mdu_a
> 
> 	sb->utime = sb->ctime;
> 	sb->events = __cpu_to_le64(1);
>-	if (info->state & MD_SB_CLEAN)
>+	if (info->state & (1<<MD_SB_CLEAN))
> 		sb->resync_offset = ~0ULL;
> 	else
> 		sb->resync_offset = 0;
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

