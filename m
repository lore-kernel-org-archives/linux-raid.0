From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Problems with Linux RAID in kernel 2.6
Date: Fri, 11 Mar 2005 16:29:10 +1100
Message-ID: <16945.11430.764708.17322@cse.unsw.edu.au>
References: <20050310181237.GA2569@nerv.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from  =?ISO-8859-1?Q?=20Jes=FAs?= Rojo  =?ISO-8859-1?Q?=20Mart=EDnez?= on Thursday March 10
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Jes=FAs_Rojo_Mart=EDnez?= <jrojomartinez@mi.madritel.es>
Cc: Ingo Molnar <mingo@elte.hu>, Jakob =?iso-8859-1?Q?=D8stergaard?= <jakob@ostenfeld.dk>, Miguel de Icaza <miguel@ximian.com>, Gadi Oxman <gadio@netvision.net.il>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 10, jrojomartinez@mi.madritel.es wrote:
> Hi,
> 
>   I have many problems with RAID in kernel 2.6.10.
..
>   And dmesg says:
> 
> md: raidstart(pid 2944) used deprecated START_ARRAY ioctl. This will not	<-- !!!
> be supported beyond 2.6								<-- !!!

Take the hint.  Don't use 'raidstart'.  It seems to work, but it will
fail you when it really counts.  In fact, I think it is failing for
you now.

Use mdadm to assemble your arrays.

> 
>   And with mdadm also fails:
> 
> centralmad:~# mdadm -R /dev/md2 
> mdadm: failed to run array /dev/md2: Invalid argument

You are using mdadm wrongly.  
You want something like:
  mdadm --assemble /dev/md2  /dev/sdb2 /dev/sdc2




> centralmad:~# cat /proc/mdstat 
> Personalities : [raid1] 
> unused devices: <none>
> 
>   Moreover, dmesg says the md driver fails:
> 
> md: bug in file drivers/md/md.c, line 1514

This is (a rather non-helpful) way of saying that you tried to start
an array which contained no devices.

NeilBrown
