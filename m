From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 code ok with 2TB + ? NEGATIVE :(
Date: Sun, 28 Nov 2004 21:27:38 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411282127220.19614@adsl.a2000.nu>
References: <200411281819.iASIJmN00402@www.watkins-home.com>
 <41AA24EC.5020206@wasp.net.au> <Pine.LNX.4.61.0411282110300.19614@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411282110300.19614@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

btw 'Large block devices' is enabled in kernel config

On Sun, 28 Nov 2004, Stephan van Hienen wrote:

> just tried creating a raid5
> it was supposed to be 2180 GB
> but mdadm -D /dev/md0 reports 131.81 GiB
> looks like it's still not supported ?
> (kernel 2.6.9-ac11 and mdadm 1.8.0)
>
kk
