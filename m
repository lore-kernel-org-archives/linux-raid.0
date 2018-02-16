From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Automatically start two-level mdadm RAID arrays (i.e. RAID 60) on
 boot?
Date: Fri, 16 Feb 2018 11:53:01 +0800
Message-ID: <30189529-36a2-b8d5-b409-8c1ee1da8037@fnarfbargle.com>
References: <CAA43vkUG8LrMUjazeYFtGVKVuTvrYRPe-UcPb21r=xeYpctpmg@mail.gmail.com>
 <20180216020217.2a9c7690@natsu>
 <4ebbb6bf-70a9-fb85-1b9f-82850a187e47@turmel.org>
 <39e0bf6b-4280-590c-9d96-013c70d4e0a4@fnarfbargle.com>
 <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Sean Caron <scaron@umich.edu>
Cc: Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/02/18 10:17, Sean Caron wrote:

> It's interesting that everyone has reported nested mdadm arrays
> starting automatically. Is there something special in mdadm.conf to
> enable this? I was starting to suspect mdadm only does a single pass
> when trying to auto-start arrays, but everyone's reports make me
> wonder if I'm just not configuring something quite right.

I've just checked onne of my Ubuntu 14 VMs and it still uses 
initramfs-utils. Try this :

Boot with break=top on the kernel cmd line. That'll drop you into the 
initramfs at the point where all your modules should be loaded but the 
scripts in /scripts/local-top/ haven't been executed yet. You can then 
run them manually (in the order specified in the ORDER file). Run the 
mdadm script with sh -x mdadm and watch what it does.

I'm using a Devuan Jessie (so basically a Debian Jessie without systemd) 
system on my test box.

test:/# mdadm --version
mdadm - v3.3.2 - 21st August 2014

Here's the current mdadm.conf :

test:/# cat /etc/mdadm/mdadm.conf
ARRAY /dev/md/1 metadata=1.0 name=unset:1 
UUID=ab86019d:ffa93771:2091569f:726abaae
ARRAY /dev/md3 metadata=1.2 name=test:3 
UUID=dbbca7b5:327751b1:895f8f11:443f6ecb
ARRAY /dev/md4 metadata=1.2 name=test:4 
UUID=1153a2e1:dc24b66d:45e319b3:333b6285
ARRAY /dev/md/2 metadata=1.2 name=unset:2 
UUID=84c30044:f3e879cd:6e492af6:f192b576
MAILADDR root

test:/# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md2 : active raid1 md4[2](W) nvme0n1[3]
       243542016 blocks super 1.2 [2/2] [UU]
       bitmap: 1/2 pages [4KB], 65536KB chunk

md4 : active raid0 sdf[0]
       249927680 blocks super 1.2 512k chunks

md3 : active raid6 sdg[0] sdm[8] sdc[7] sde[6] sdi[5] sdk[4] sdl[3] 
sdj[2] sdh[1]
       13673684416 blocks super 1.2 level 6, 64k chunk, algorithm 2 
[9/9] [UUUUUUUUU]
       bitmap: 0/15 pages [0KB], 65536KB chunk

md1 : active raid1 sdb1[2] sda1[3]
       524224 blocks super 1.0 [2/2] [UU]


So md2 is a RAID1 made from md4 (a RAID0) and an nvme drive.
I will say over the years I've made some pretty pathological test 
configurations with multiple stacks as far as 4 md devices deep and I've 
never had an issue with them starting in sequence.

Trace your boot sequence and bring the box up by hand to find out why 
it's not auto-starting.

Brad
