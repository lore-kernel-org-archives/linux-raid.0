From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Posible bug on RAID 1 driver
Date: Mon, 28 Feb 2005 16:09:18 +1100
Message-ID: <16930.42878.290455.728204@cse.unsw.edu.au>
References: <20050223212156.GA11589@nerv.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from  =?ISO-8859-1?Q?=20Jes=FAs?= Rojo  =?ISO-8859-1?Q?=20Mart=EDnez?= on Wednesday February 23
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Jes=FAs_Rojo_Mart=EDnez?= <jrojomartinez@mi.madritel.es>
Cc: Ingo Molnar <mingo@elte.hu>, Jakob =?iso-8859-1?Q?=D8stergaard?= <jakob@ostenfeld.dk>, Miguel de Icaza <miguel@ximian.com>, Gadi Oxman <gadio@netvision.net.il>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 23, jrojomartinez@mi.madritel.es wrote:
> Hi,
> 
>   The Linux RAID crushes when recuntructing a disk.
> 
...
> 
>   I use a 2.4.29 kernel (on a Debian sarge GNU/Linux).
...
> unused devices: <none>
> Personalities : [raid1] 
> read_ahead 1024 sectors
> md1 : active raid1 sdb1[2] sdd1[0] sdc1[1]
>       999872 blocks [2/2] [UU]
>       
> unused devices: <none>
> centralmad:~# DEVICE=/dev/sdc1 ; raidsetfaulty /dev/md1 $DEVICE ; raidhotremove /dev/md1 $DEVICE ; cat /proc/mdstat; 
> Personalities : [raid1] 
> read_ahead 1024 sectors
> md1 : active raid1 sdb1[2] sdd1[0]
>       999872 blocks [2/1] [U_]
>       [>....................]  recovery =  0.0% (0/999872) finish=166.6min speed=0K/sec
> unused devices: <none>


There is a race condition in the 2.4 kernels.  If you fail a drive and
then removing it instantly, you can hit problems.  My advice is to not
do that. (or use 2.6).

NeilBrown
