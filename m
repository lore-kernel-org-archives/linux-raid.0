From: Frank Baumgart <frank.baumgart@gmx.net>
Subject: Re: RAID5 superblocks partly messed up after degradation
Date: Sat, 14 Apr 2007 00:09:08 +0200
Message-ID: <461FFF84.9020400@gmx.net>
References: <461A8037.7050300@gmx.net> <17948.7830.809009.253759@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17948.7830.809009.253759@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> I'll see what I can do :-)
>
The problem could be resolved by removing one of the two external SATA 
controllers (PCI card with ALI M5283) and using Kernel 2.6.20.6
Only removing the ALI PCI card brought the numbering scheme in line 
again so the old (degraded) array became accessible again. Even with no 
disks attached to it, the kernel did not get its disk naming in shape to 
assemble more than one ("sdd") of the four old devices although all 4 
devices could be accessed with "mdadm --examine" or fdisk.
Additionally, using 2.6.20.6 resolved the ghost device issue where one 
SATA drive appeared additionally as a PATA drive, too. Now I could 
create the new array and copy over all data from the degraded one. 
<wipes sweat>

> Are there any kernel logs that this time which might make it clear
> what is happening?
>   
Not really, the logs contain quite a mess of trying different kernels 
and system configurations to get the data back
with the disc naming following the state of the moon.
I produced too much sweat to get the data back so I am reluctant to try 
anything now that it works until my backup
scheme is somewhat improved :)

Thank you for your help.

Frank

