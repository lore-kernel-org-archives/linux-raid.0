From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 slow
Date: Mon, 29 Nov 2004 12:13:50 -0500
Message-ID: <200411291713.iATHDtN05760@www.watkins-home.com>
References: <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: 'Stephan van Hienen' <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Very odd, RAID5 reading should be about the same as RAID0.
And your old array confirms that.
My guess is RAID5 needs some help.  Neil?  Any ideas?

Is your stripe size the same on both?
Did you allow your array to re-sync before the tests?

Guy

-----Original Message-----
From: Stephan van Hienen [mailto:raid@a2000.nu] 
Sent: Monday, November 29, 2004 3:52 AM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: raid5 slow

> it's only a bit slow :
>
> Version  1.03       ------Sequential Output------ --Sequential Input- 
> --Random-
>                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP /sec

> %CP
> storage.a2000.nu 2G 26828  99 123983  73 58525  57 27336  99 171371  96
583.9 
> 4
>                    ------Sequential Create------ --------Random 
> Create--------
>                    -Create-- --Read--- -Delete-- -Create-- --Read--- 
> -Delete--
>              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP /sec 
> %CP
>                 16  1023  12 +++++ +++   920  11  1004  14 +++++ +++ 722
9
>
storage.a2000.nu,2G,26828,99,123983,73,58525,57,27336,99,171371,96,583.9,4,1
6,1023,12,+++++,+++,920,11,1004,14,+++++,+++,722,9

created a raid0 with the same disks :

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 2G 28435  99 219329  73 102949  51 29704  99 275323  62 
639.5   2
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16 10108  84 +++++ +++  8825  69  9877  88 +++++ +++ 
7546  66
storage.a2000.nu,2G,28435,99,219329,73,102949,51,29704,99,275323,62,639.5,2,
16,10108,84,+++++,+++,8825,69,9877,88,+++++,+++,7546,66


shouldn't the raid be about the same ?

now i get 275MB/sec with raid0 (14 disks)
171MB/sec with raid5 (14 disks)

while the old raid5 situation was 257MB/sec with raid5 (13 disks)

-- 
No virus found in this incoming message.
Checked by AVG Anti-Virus.
Version: 7.0.289 / Virus Database: 265.4.3 - Release Date: 11/26/2004
 

