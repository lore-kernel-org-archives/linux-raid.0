From: "Nicolas Meaux" <nicolas.meaux@artabel.net>
Subject: Re: Crashing a software raid 5 partition ( disk trouble )
Date: Thu, 12 Jun 2003 12:06:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00db01c330ca$5ae72290$3001a8c0@melkor>
References: <007201c330b9$c316f310$3001a8c0@melkor><16104.22045.492729.835610@gargle.gargle.HOWL> <16104.22361.508001.916567@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for you quick respond Neil  ;)

>    mdadm -A --force /dev/md2 /dev/sd[a-f]

So, i type this command :

# mdadm -A --force /dev/md2 /dev/sd[a-h]
mdadm: /dev/md2 has been started with 7 drives.

( i do a [a-h] , because i have 8 scsi disk )

I try too mount md2, it work fine, but :
# ls -al
ls: nohup.out: Input/output error
ls: tape.sh: Input/output error
ls: .viminfo: Input/output error
ls: .bash_history: Input/output error
ls: .bashrc~: Input/output error
ls: .xauth: Input/output error

It seem that there is many errors on the partition.
So, in good newbie, i decided too reboot the machine, but now and since one
hour, he is blocking on these lines :

[...]
md: updating md2 RAID superblock device
md: sdg [events: 000005a]<6>write sdg's sb offset 35843584
md: sdh [events: 000005a]<6>write sdh's sb offset 35843584
md: sde [events: 000005a]<6>write sde's sb offset 35843584
md: sdd [events: 000005a]<6>write sdd's sb offset 35843584


But, there is disk activity on the first one.

It's normal ? does RAID reconsctruct itsef ? if so , why did not he say that
he is doing it ?


    Nicolas


