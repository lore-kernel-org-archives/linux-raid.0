From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: Spare disk could not sleep / standby  [probably dangerous
	PATCH]
Date: Wed, 09 Mar 2005 04:44:08 -0600
Message-ID: <1110365048.6556.14.camel@langvan2.homenetwork>
References: <422D327D.11718.F8DB3@localhost>
	 <200503080414.j284EG510309@www.watkins-home.com>
	 <16941.11443.107607.735855@cse.unsw.edu.au>
	 <200503091553.j29FrKO2009044@pec6.gallier.dorf>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503091553.j29FrKO2009044@pec6.gallier.dorf>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter,

After applying this patch, have you tried stop and restart the MD
array?  I believe the spares will be kicked out in analyze_sbs()
function (see the second ITERATE_RDEV)

--
Regards,
Mike T.


On Wed, 2005-03-09 at 09:53, Peter Evertz wrote:
> This patch removes my problem. I hope it doesn't have influence on the 
> stability of
> the system.
> It is simple: The Update routine skips normaly only "faulty" disks. Now it 
> skips all disk
> that are not part of the working array ( raid_disk == -1 )
> I made some testing, but surely not all, so : 
> 
> DON'T APPLY TO YOUR SYSTEM WITH IMPORTENT DATA ! 
> 
> Regards
> Peter 
> 
>  --- md.c.orig   2005-01-14 16:33:49.000000000 +0100
> +++ md.c        2005-03-09 15:27:23.000000000 +0100
> @@ -1340,14 +1340,14 @@
>        ITERATE_RDEV(mddev,rdev,tmp) {
>                char b[BDEVNAME_SIZE];
>                dprintk(KERN_INFO "md: ");
>  -               if (rdev->faulty)
>  -                       dprintk("(skipping faulty ");
> +               if (rdev->faulty || rdev->raid_disk < 0)
> +                       dprintk("(skipping faulty/spare "); 
> 
>                dprintk("%s ", bdevname(rdev->bdev,b));
>  -               if (!rdev->faulty) {
> +               if (!rdev->faulty && !rdev->raid_disk <0 ) {
>                        err += write_disk_sb(rdev);
>                } else
>  -                       dprintk(")\n");
> +                       dprintk("<%d>)\n",rdev->raid_disk);
>                if (!err && mddev->level == LEVEL_MULTIPATH)
>                        /* only need to write one superblock... */
>                        break; 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

