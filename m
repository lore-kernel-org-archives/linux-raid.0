From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 code ok with 2TB + ? NEGATIVE :(
Date: Sun, 28 Nov 2004 21:45:58 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411282144460.19614@adsl.a2000.nu>
References: <200411281819.iASIJmN00402@www.watkins-home.com>
 <41AA24EC.5020206@wasp.net.au> <Pine.LNX.4.61.0411282110300.19614@adsl.a2000.nu>
 <Pine.LNX.4.61.0411282127220.19614@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411282127220.19614@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 Nov 2004, Stephan van Hienen wrote:

> btw 'Large block devices' is enabled in kernel config
argh and i copyed it to the wrong place
so i was still running a non LBD kernel

]# mdadm -D /dev/md0
/dev/md0:
         Version : 00.90.01
   Creation Time : Sun Nov 28 21:44:33 2004
      Raid Level : raid5
      Array Size : 2285700352 (2179.81 GiB 2340.56 GB)
     Device Size : 175823104 (167.68 GiB 180.04 GB)

now running a resync
after that i'll run badblocks on it to test if i can read/write to the 
complete array

