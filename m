From: "Michael Theodoulou" <michael.theodoulou@gmail.com>
Subject: Re: RAID 5 Whole Devices - Partition
Date: Tue, 30 May 2006 22:25:45 +0300
Message-ID: <4e40e93e0605301225o3e80972odca14756a9c07106@mail.gmail.com>
References: <4e40e93e0605301008x34bc03dekb9a35952668e7a14@mail.gmail.com>
	 <20060530174920.GG4022@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060530174920.GG4022@percy.comedia.it>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/30/06, Luca Berra <bluca@comedia.it> wrote:
> On Tue, May 30, 2006 at 08:08:03PM +0300, Michael Theodoulou wrote:
> >Hello,
> >
> >I am trying to create a RAID5 array out of 3 160GB SATA drives. After
> >i create the array i want to partition the device into 2 partitions.
> >
> >The system lies on a SCSI disk and the 2 partitions will be used for
> >data storage.
> >The SATA host is an HPT374 device with drivers compiled in the kernel.
> >
> >These are the steps i followed
> >
> >mdadm -Cv --auto=part /dev/md_d0 --chunk=64 -l 5 --raid-devices=3
> >/dev/hde /dev/hdi /dev/hdk
> >
> >Running this command notifies me that there is an ext2 fs on one of
> >the drives even if i fdisked them before and removed all partititions.
> ....
> >Furthermore when i fdisk the drives after all of this i can see the 2
> >partitions on /dev/hde and /dev/hdi but /dev/hdk shows that no
> >partition exists. Is this a sign of data corruption or drive failure?
> are you sure you removed all partitions before creating the md

I run fdisk on each disk and deleted all partitions. Wrote the
partition table to disk. Removed /etc/mdadm.conf, disabled mdmonitor
and rebooted.
>
> >Shouldnt all 3 drives show the same partition information?
> the drives should not contain any partition information.
> (well actually the first will show an invalid partition table, since the
> partition of the mdp array will be written exactly at the beginning of
> the first raid disk.

I havent partitioned the disks, all the partitions where created after
running mdadm to create the array.

Michael
