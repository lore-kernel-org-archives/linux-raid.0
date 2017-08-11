From: Sarah Newman <srn@prgmr.com>
Subject: Re: md0 device gone, disks busy
Date: Thu, 10 Aug 2017 19:55:03 -0700
Message-ID: <f99b9fb1-e71b-33ad-4145-1ce53d926d53@prgmr.com>
References: <CAHnOR0OrjQD2=o4uSU4N3_W+UvHQzpcW=oYB0cmPU_kPQxzhcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHnOR0OrjQD2=o4uSU4N3_W+UvHQzpcW=oYB0cmPU_kPQxzhcg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mr Typo <euroregistrar@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/10/2017 01:26 PM, Mr Typo wrote:
> Hello everyone,
> 
> i had a power outage 2 days ago and when i came home i found my linux
> box not booting up anymore. After some commands i found out that there
> is a problem with a device not beeing mounted because md0 is missing.
> 
> I tried to find out what is going on, but i cannot understand what is
> going on.  i hope you can help me. Linux is a CentOS7.
> 
> I am posting the current status of the box below:
> 
> thank you all in advance
> 
> kind regards
> Andy

> [root@quad ~]# mdadm -Esv
> ARRAY /dev/md/0  level=raid5 metadata=1.2 num-devices=4
> UUID=9d020f27:c0542472:b95a18d2:5741114d name=quad.:0
>    devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1

It's running, it's just called /dev/md/0 instead. You should be able to temporarily change the name with

mdadm --stop /dev/md/0
mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1

I think for centos 7, to change what happens on boot you can edit /etc/mdadm.conf to explicitly name the array and run 'dracut -f' to update the
initial ram disk that loads on boot before the actual root file system is mounted. 'man mdadm.conf' has an example of the mdadm.conf syntax.

--Sarah
