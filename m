From: Thomas Grawert <thomasgrawert0282@gmail.com>
Subject: Re: help requested for mdadm grow error
Date: Mon, 25 May 2020 23:22:42 +0200
Message-ID: <e1ad56b2-df70-bc6a-9a81-333230d558c2@gmail.com>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
 <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
 <5ECC1488.3010804@youngman.org.uk>
 <4891e1e8-aaee-b36b-4131-ca7deb34defd@gmail.com>
 <alpine.DEB.2.20.2005252132080.7596@uplift.swm.pp.se>
 <103b80fa-029f-ecdc-d470-5cc591dc8dd0@gmail.com>
 <e1a4a609-2068-b084-59a6-214c88798966@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e1a4a609-2068-b084-59a6-214c88798966@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't think I've got an mdadm.conf ... and everything to me looks okay 
but just not working.
>
> Next step - how far has the reshape got? I *think* you might get that 
> from "cat /proc/mdstat". Can we have that please ... I'm *hoping* it 
> says the reshape is at 0%.
>
> Cheers,
> Wol


root@nas:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : inactive sda1[0] sdf1[5] sde1[4] sdd1[2] sdc1[1]
       58593761280 blocks super 1.2

unused devices: <none>
root@nas:~#

nothing... the reshaping run about 5min. before power loss.
