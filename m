From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 slow
Date: Tue, 30 Nov 2004 01:50:29 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
 <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
 <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu> <16811.48945.141392.294625@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16811.48945.141392.294625@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Nov 2004, Neil Brown wrote:

> On Monday November 29, raid@a2000.nu wrote:
>>
>> now i get 275MB/sec with raid0 (14 disks)
>> 171MB/sec with raid5 (14 disks)
>>
>> while the old raid5 situation was 257MB/sec with raid5 (13 disks)
>
> I presume you are only looking at 'read' speed here.
yes i'm looking at the read spead

just tested 2.6.10-rc2

142148

this is 50% of the performance i get with the 2.4 kernel
(the 171MB/sec i got yesterday with 14 disks was also with xfs)
(xfs on 14d r5 gives 171371 read/ext3 on 14 r5 gives 132845 read)

(2.6.10-rc2 13d r5 ext3)

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000.nu 2G 24730  99 108265  88 59460  59 25759  91 142148  69 
586.8   3
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1432  78 +++++ +++ +++++ +++  1456  77 +++++ +++ 
4908  97
storage.a2000.nu,2G,24730,99,108265,88,59460,59,25759,91,142148,69,586.8,3,16,1432,78,+++++,+++,+++++,+++,1456,77,+++++,+++,4908,97

>
> There is a read optimisation that I haven't implemented in 2.6 yet
> that could  account for about a 10% difference, but a 30% difference
> definitely surprises me.
>
> Normally raid5 will read into the stripe cache, and then copy data out
> of the stripe cache and into the request buffer for reads.
> The optimisation is to read directly into the request buffer in
> situations where no degraded stripes or pending write requests.  This
> optimisation is implemented in 2.4 and gave me about a 10% speedup on
> sequential reads.  Its substantially more complicated in 2.6...
>
> I might do a bit of testing myself, but more results from others would
> be helpful...
>
> NeilBrown
>
