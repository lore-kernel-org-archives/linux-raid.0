From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Optimization report for Justin .
Date: Mon, 1 Oct 2007 16:22:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710011621260.10990@p34.internal.lan>
References: <Pine.LNX.4.64.0710011234510.28195@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710011234510.28195@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

So you got 2x with those optimizations I mentioned?  Nice, did you 
previously get that speed, or?

On Mon, 1 Oct 2007, Mr. James W. Laferriere wrote:

> 	Hello Justin ,  Three seperate single runs of bonnie(*) .
> 	Please note ,  the linux-2.6.23-rc6 ,  Concerns your email of
> 	this weekend about "Subject: Bonnie++ with 1024k stripe SW/RAID5
> 	causes kernel to goto D-state" .
> 	No lockups or hangs were noticed .
> 		Hth ,  JimL
>
> -	No optimizations at all or mount options . ~ 33MB/s
> 	mount -t xfs /dev/md3 /md3
> -	Just the suggested hardware optimizations . ~ 66MB/s
> 	(minus: disable Raptor NCQ  & sync_speed_max left at system default 
> (200000))
> -	With the additional optimization for XFS mount time . ~ 72MB/s
> 	mount -t xfs -onoatime,nodiratime,logbufs=8,logbsize=262144 /dev/md3 
> /md3
>
> 	Specifics:
>
> 	Kernel: linux-2.6.23-rc6+(these 2 patches...
> [SCSI] Addition to pci_ids.h for ATTO Technology, 
> Inc.linux/kernel/git/jejb/scsi-misc-2.6.git , commit: 
> d43639784817e4c9acaffd0952a1dc8ab6ecc076
> [SCSI] mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030 
> linux/kernel/git/jejb/scsi-misc-2.6.git , commit: 
> 5e394a08b72f40b059d05c44268769ce87ded11a
> )
>
> (*)	/root/bonnie++-1.03a/bonnie++ -u0:0 -d /md3 -s 131072 -f
>
> 	bonnie++ output:
>
> -	No optimizations at all or mount options .
> 	mount -t xfs /dev/md3 /md3
>
> Using uid:0, gid:0.
> Writing intelligently...done
> Rewriting...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version  1.03       ------Sequential Output------ --Sequential Input- 
> --Random-
>                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec 
> %CP
> filesrv2       128G           33575  17 27009  15           350317  44 468.0 
> 1
>                    ------Sequential Create------ --------Random 
> Create--------
>                    -Create-- --Read--- -Delete-- -Create-- --Read--- 
> -Delete--
>              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
> %CP
>                 16  1506   4 +++++ +++  1267   3  1620   6 +++++ +++  1121 
> 5
> filesrv2,128G,,,33575,17,27009,15,,,350317,44,468.0,1,16,1506,4,+++++,+++,1267,3,1620,6,+++++,+++,1121,5
>
>
>
> -	Just the suggested hardware optimizations .
> 	(minus: disable Raptor NCQ  & sync_speed_max left at system default 
> (200000))
>
> Using uid:0, gid:0.
> Writing intelligently...done
> Rewriting...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version  1.03       ------Sequential Output------ --Sequential Input- 
> --Random-
>                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec 
> %CP
> filesrv2       128G           66976  55 51460  45           377672  78 470.3 
> 3
>                    ------Sequential Create------ --------Random 
> Create--------
>                    -Create-- --Read--- -Delete-- -Create-- --Read--- 
> -Delete--
>              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
> %CP
>                 16  1707   8 +++++ +++  1585   8  2039   8 +++++ +++   953 
> 8
> filesrv2,128G,,,66976,55,51460,45,,,377672,78,470.3,3,16,1707,8,+++++,+++,1585,8,2039,8,+++++,+++,953,8
>
>
>
> -	With the additional optimizations at XFS mount time .
> 	mount -t xfs -onoatime,nodiratime,logbufs=8,logbsize=262144 /dev/md3 
> /md3
>
> Using uid:0, gid:0.
> Writing intelligently...done
> Rewriting...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version  1.03       ------Sequential Output------ --Sequential Input- 
> --Random-
>                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec 
> %CP
> filesrv2       128G           72819  35 52979  28           384975  52 479.8 
> 1
>                    ------Sequential Create------ --------Random 
> Create--------
>                    -Create-- --Read--- -Delete-- -Create-- --Read--- 
> -Delete--
>              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec 
> %CP
>                 16  2359  21 +++++ +++  2339  20  2880  24 +++++ +++  2060 
> 20
> filesrv2,128G,,,72819,35,52979,28,,,384975,52,479.8,1,16,2359,21,+++++,+++,2339,20,2880,24,+++++,+++,2060,20
>
> -- 
> +-----------------------------------------------------------------+
> | James   W.   Laferriere | System   Techniques | Give me VMS     |
> | Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
> | babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
> +-----------------------------------------------------------------+
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
