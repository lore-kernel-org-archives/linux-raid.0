From: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Subject: Re: mdadm-3.2.5 coming soon :-(
Date: Tue, 15 May 2012 17:22:27 +0200
Message-ID: <4FB274B3.8040907@intel.com>
References: <20120503142201.649766de@notabene.brown> <20120515215020.76fd9c6f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120515215020.76fd9c6f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Doug Ledford <dledford@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Dan Williams <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, Clint Byrum <clint@ubuntu.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Tomczak, Marcin" <marcin.tomczak@intel.com>
List-Id: linux-raid.ids

> If anyone knows of any other issues that have cropped up wit 3.2.4, please
> let me know.
>
> Thanks,
> NeilBrown

Since mdadm-3.2.4 creating volumes using IMSM containers is impossible 
(segfaults), unless the kernel is 3.1.x or higher (for instance 
everything SEEMS to work in RHEL 7.0 Alpha and openSUSE 12.1). Full 
story from SLES 11 SP2 (kernel-3.0.13-0.27-default) with mdadm-3.2.4 :

$ mdadm --zero-superblock /dev/sd[cd]
$ mdadm -C /dev/md/imsm0 -a md -e imsm -n 2 /dev/sd[cd] -R

     [...]

$ tail /var/log/messages

     May 15 17:16:10 gklab-128-174 kernel: [  317.653470] md: bind<sdc>
     May 15 17:16:10 gklab-128-174 kernel: [  317.653519] md: bind<sdd>
     May 15 17:16:11 gklab-128-174 udevd-work[5249]: '/sbin/mdadm 
--detail --export /dev/md127' unexpected exit with status 0x000b
     May 15 17:16:11 gklab-128-174 kernel: [  317.701434] mdadm[5250]: 
segfault at 78 ip 0000000000450c4f sp 00007fff6c99ada0 error 4 in 
mdadm[400000+69000]

$ mdadm -C /dev/md/raid1_2disks -a md -l 1  --size 1500000 -n 2 
/dev/sd[cd] -R -f

     mdadm: cannot open device: 11:0
     [...]
     mdadm: cannot open device: 11:0
     [...]
     Segmentation fault

$ tail /var/log/messages

     May 15 17:18:36 gklab-128-174 kernel: [  463.291235] mdadm[5298]: 
segfault at 78 ip 0000000000450c4f sp 00007fff8ad887e0 error 4 in 
mdadm[400000+69000]

Similiar story in RHEL 6.3 Beta, those errors don't happen with kernel 
 >= 3.1.x though (or mdadm-3.2.3 :)).

Maciek N
