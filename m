From: Peter Evertz <leo2@pec.homeip.net>
Subject: Re: Spare disk could not sleep / standby [probably dangerous PATCH]
Date: Thu, 10 Mar 2005 00:20:24 +0100
Message-ID: <200503092320.j29NKOSs008020@pec6.gallier.dorf>
References: <422D327D.11718.F8DB3@localhost>
            <200503080414.j284EG510309@www.watkins-home.com>
            <16941.11443.107607.735855@cse.unsw.edu.au>
            <200503091553.j29FrKO2009044@pec6.gallier.dorf>
            <1110365048.6556.14.camel@langvan2.homenetwork>
            <200503092005.j29K56j2013533@pec6.gallier.dorf>
            <1110385774.6587.46.camel@langvan2.homenetwork>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="utf-8"
Content-Transfer-Encoding: 7bit
In-Reply-To: <1110385774.6587.46.camel@langvan2.homenetwork>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Tran <mhtran@us.ibm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Tran writes:
> I tried the patch and immediately found problems. 
> 
> On creation of raid1 array, only the spare has md superblock, the raid
> disks has no superblock.  For instance: 
> 
> mdadm -C /dev/md0 -l 1 -n 2 /dev/hdd1 /dev/hdd2 -x 1 /dev/hdd3
> [wait for resync to finish if you want to...]
> mdadm --stop /dev/md0
> mdadm --examine /dev/hdd1 (no super block found)
> mdadm --examine /dev/hdd2 (no super block found)
> mdadm --examine /dev/hdd3 (nice output) 
> 
> If you want to skip spares, you will need to alter the patch (see below) 
> 
Ooops ! I should't post patches for everyone. Nevertheless it workes for me, 
but I see that your version, is much better. Testing for raid_disk <0 is not 
a good idea when you (re)create an array. The test for "in_sync" is better, 
but still don't know if it works under all circumstances. 

Thanks
Peter 

> On Wed, 2005-03-09 at 14:05, Peter Evertz wrote:
>> Mike Tran writes:  
>> 
>> > Hi Peter, 
>> > 
>> > After applying this patch, have you tried stop and restart the MD
>> > array?  I believe the spares will be kicked out in analyze_sbs()
>> > function (see the second ITERATE_RDEV)
>> mdadm ( v1.6.0 - 4 June 2004 )
>> shows the arrays complete including spare.
>> /proc/mdstat is ok  
>> 
>> I booted with my patched raid modules. So analyze_sbs() should have run.
>> Maybe it works only for 0.90 superblocks, I haven't tried 1.00  
>> 
>> No problems yet. If it really fails the hard way, I will go to the next 
>> Internetcafe and tell you about it :)  
>> 
>> Peter
>> > 
>> > --
>> > Regards,
>> > Mike T. 
>> > 
>> > 
>> > On Wed, 2005-03-09 at 09:53, Peter Evertz wrote:
>> >> This patch removes my problem. I hope it doesn't have influence on the 
>> >> stability of
>> >> the system.
>> >> It is simple: The Update routine skips normaly only "faulty" disks. Now it 
>> >> skips all disk
>> >> that are not part of the working array ( raid_disk == -1 )
>> >> I made some testing, but surely not all, so :  
>> >> 
>> >> DON'T APPLY TO YOUR SYSTEM WITH IMPORTENT DATA !  
>> >> 
>> >> Regards
>> >> Peter  
>> >> 
>> >>  --- md.c.orig   2005-01-14 16:33:49.000000000 +0100
>> >> +++ md.c        2005-03-09 15:27:23.000000000 +0100
>> >> @@ -1340,14 +1340,14 @@
>> >>        ITERATE_RDEV(mddev,rdev,tmp) {
>> >>                char b[BDEVNAME_SIZE];
>> >>                dprintk(KERN_INFO "md: ");
>> >>  -               if (rdev->faulty)
>> >>  -                       dprintk("(skipping faulty ");
>> >> +               if (rdev->faulty || rdev->raid_disk < 0)
>> >> +                       dprintk("(skipping faulty/spare ");  
>> >> 
>> >>                dprintk("%s ", bdevname(rdev->bdev,b));
>> >>  -               if (!rdev->faulty) {
>> >> +               if (!rdev->faulty && !rdev->raid_disk <0 ) {
> 
> if (!rdev->faulty && rdev->in_sync)
> 	err += write_disk_sb(rdev);
> else {
> 	if (rdev->faulty)
> 		dprintk(" faulty.\n");
> 	else
> 		dprintk(" spare.\n");
> } 
> 
> /*
>  * Don't try this :(
>  * because this still breaks creation of new md array and..
>  * for existing arrays with spares, the spares will be kicked out when 
>  * the arrays are re-assembled.
>  */ 
> 
> 
> --
> Regards,
> Mike T. 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 
> 
 

