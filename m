From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux Software RAID 5 + XFS Multi-Benchmarks / 10 Raptors
 Again
Date: Wed, 16 Jan 2008 13:19:53 -0500 (EST)
Message-ID: <alpine.DEB.0.999999.0801161316280.1151@p34.internal.lan>
References: <alpine.DEB.0.999999.0801161105510.16168@p34.internal.lan> <29a863790801161009h7bb1f0f7v34bc893fce338567@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790801161009h7bb1f0f7v34bc893fce338567@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

On Wed, 16 Jan 2008, Greg Cormier wrote:

> What sort of tools are you using to get these benchmarks, and can I
> used them for ext3?
>
> Very interested in running this on my server.
>
>
> Thanks,
> Greg
>

You can use whatever suits you, such as untar kernel source tree, copy files, untar backups, etc--, you should benchmark specifically what *your* workload is.

Here is the skeleton, using bash:: (don't forget to turn off the cron 
daemon)

for i in 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536
do
   cd /
   umount /r1
   mdadm -S /dev/md3
   mdadm --create --assume-clean --verbose /dev/md3 --level=5 --raid-devices=10 --chunk=$i --run /dev/sd[c-l]1

   /etc/init.d/oraid.sh # to optimize my raid stuff

   mkfs.xfs -f /dev/md3
   mount /dev/md3 /r1 -o logbufs=8,logbsize=262144

   # then simply add what you do often here
   # everyone's workload is different
   /usr/bin/time -f %E -o ~/$i=chunk.txt bash -c 'dd if=/dev/zero of=/r1/bigfile bs=1M count=10240; sync'
done

Then just, grep : /root/*chunk* | sort -n to get the results in the same format.

Justin.
