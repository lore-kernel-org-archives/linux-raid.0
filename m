From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Problem with mdadm and raidstart
Date: Fri, 2 Apr 2004 11:21:08 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16492.49156.322965.117365@notabene.cse.unsw.edu.au>
References: <20040401192015.40822.qmail@web14522.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Don Jessup on Thursday April 1
To: donj@asaca.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 1, donj@asaca.com wrote:
> 
> 
>    I have been testing disk failures with RAID5.   I have problems that I
>   have run into that happens with raidstart and mdadm. 
> 
>     Here is the scenario.   I stop a healthy raid5.     I then do either one
>    of the following:  I poweroff the first disk in the raid5 and remove it or
>    I zero out the raid superblock on the first disk.     I then go ahead and
>     try to start the raid either by raidstart command or  
>      mdadm --assemble --run  /dev/md8   /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
>      /dev/sde1 

When asking mdadm to assemble an array, you need to tell it what array
to assemble.
The above command essentially says "Assemble the array that /dev/sda1
is part of, using it as well as b,c,d,e".
Obviously this will fail if sda is bad.

You can discover this fact about mdadm if you read the man page.
In the section "ASSEMBLE MODE", it says:

       This usage assembles one or more raid arrays from  pre-existing  compo-
       nents.  For each array, mdadm needs to know the md device, the identity
       of the array, and a number of component-devices. These can be found  in
       a number of ways.

A little later it says:

       The  identity  can  be  given with the --uuid option, with the --super-
       minor option, can be found  in the config file, or will be  taken  from
       the  super  block  on  the first component-device listed on the command
       line.

giving three ways.  You are using the last.

If you read the rest of the man page, I'm sure you will figure out how
to do what you want, and possibly a good many other things too.

NeilBrown

> 
>      Both of these commands fail.  I do admit when using the mdadm command I
>      can get the RAID5 to start if I leave out the first disk. 
> 
>     But when I try this same test with any other disk in the raid set (so any
>     disk other than disk 0 ) the command raidstart works and I 
>      assuming mdadm command would work as well.   That is what I would like 
>     to happen with disk0 as well.    Is there anyway to start
>     a degraded raid set consistently without having to manually figure 
>     out which disk failed?   
> 
> 
>     Any way to make this work?  If it is a simple fix I could do it myself
>     if someone could point me to right direction or maybe there is a latter
>     version of the mdadm command that this is not a problem.  Any one ?
>     Any ideas?
> 
>     I'm running linux 2.4.22 kernel with mdadm - v1.3.0 - 29 Jul 2003.
> 
>     Thank You
> 
> 
> 
>    
>  
> 
>     
> 
> 
> 
> =====
> Don Jessup
> Asaca/Shibasoku Corp. of America
> 400 Corporate Circle, Unit G
> Golden, CO  80401
> 303-278-1111 X232
> donj@asaca.com
> http://www.asaca.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
