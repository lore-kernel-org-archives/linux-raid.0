From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: strange problem with my raid5
Date: Thu, 31 Mar 2011 17:24:20 +0100
Message-ID: <4D94AAB4.2050900@gmail.com>
References: <AANLkTinEcLaQAdoFgbV6+UGkPYKTgBass8J8pUBQ3h_X@mail.gmail.com>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinEcLaQAdoFgbV6+UGkPYKTgBass8J8pUBQ3h_X@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I think the normal thing to try in this situation is:

  mdadm --assemble --scan

and if that doesn't work, people normally ask for:
  mdadm -E /dev/sd?? for each appropriate drive which should be in the array

have a look at dmesg too ?

I don't know much about md, I just lurk so apologies if you already know 
this.

cheers
Simon

On 30/03/2011 13:34, hank peng wrote:
> Hi,all:
> I created a raid5 array which consists of 15 disks, before recovering
> is done, a power failure event occured. After power is recovered, the
> machine box started successfully but "cat /proc/mdstat" gave no
> message, previously created raid5 was gone. I check kernel messages,
> it is as follows:
>
> <snip>
> bonding: bond0: enslaving eth1 as a backup interface with a down link.
> svc: failed to register lockdv1 RPC service (errno 97).
> rpc.nfsd used greatest stack depth: 5440 bytes left
> md: md1 stopped.
> iSCSI Enterprise Target Software - version 1.4.1
> </snip>
>
> In normal case, md1 should bind its disks after printing "md: md1
> stopped", then what happened in this cituation?
> BTW, my kernel version is 2.6.31.6.
>
>
