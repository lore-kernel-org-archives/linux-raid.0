From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 code ok with 2TB + ?
Date: Mon, 29 Nov 2004 00:34:43 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411290033010.28142@adsl.a2000.nu>
References: <200411281819.iASIJmN00402@www.watkins-home.com>
 <41AA24EC.5020206@wasp.net.au> <Pine.LNX.4.61.0411282110300.19614@adsl.a2000.nu>
 <Pine.LNX.4.61.0411282127220.19614@adsl.a2000.nu>
 <Pine.LNX.4.61.0411282144460.19614@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411282144460.19614@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 Nov 2004, Stephan van Hienen wrote:

> now running a resync
> after that i'll run badblocks on it to test if i can read/write to the 
> complete array

resync finished without any problems
i wanted to run badblocks on the /dev/md0 to check
but it looks like badblocks doesn't support 2TB + :

]# badblocks -sw -p99 -c8192 /dev/md0
Writing pattern 0xaaaaaaaa:                    126464/-2009266944

any other hints for testing the raid ?

