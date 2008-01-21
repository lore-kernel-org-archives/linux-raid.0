From: Neil Brown <neilb@suse.de>
Subject: Re: array doesn't run even with --force
Date: Mon, 21 Jan 2008 12:13:40 +1100
Message-ID: <18323.61892.577574.287408@notabene.brown>
References: <18323.53416.900135.357320@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Sunday January 20
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 20, carlos@fisica.ufpr.br wrote:
> I've got a raid5 array with 5 disks where 2 failed. The failures are
> occasional and only on a few sectors so I tried to assemble it with 4
> disks anyway:
> 
> # mdadm -A -f -R /dev/md<number> /dev/disk1 /dev/disk2 /dev/disk3 /dev/disk4
> 
> However mdadm complains that one of the disks has an out-of-date
> superblock and kicks it out, and then it cannot run the array with
> only 3 disks.
> 
> Shouldn't it adjust the superblock and assemble-run it anyway? That's
> what -f is for, no? This is with kernel 2.6.22.16 and mdadm 2.6.4.

Please provide actual commands and actual output.
Also add "--verbose" to the assemble command
Also provide "--examine" for all devices.
Also provide any kernel log messages.

Thanks,
NeilBrown
