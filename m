From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID 5 Whole Devices - Partition
Date: Tue, 30 May 2006 19:49:20 +0200
Message-ID: <20060530174920.GG4022@percy.comedia.it>
References: <4e40e93e0605301008x34bc03dekb9a35952668e7a14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4e40e93e0605301008x34bc03dekb9a35952668e7a14@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 30, 2006 at 08:08:03PM +0300, Michael Theodoulou wrote:
>Hello,
>
>I am trying to create a RAID5 array out of 3 160GB SATA drives. After
>i create the array i want to partition the device into 2 partitions.
>
>The system lies on a SCSI disk and the 2 partitions will be used for
>data storage.
>The SATA host is an HPT374 device with drivers compiled in the kernel.
>
>These are the steps i followed
>
>mdadm -Cv --auto=part /dev/md_d0 --chunk=64 -l 5 --raid-devices=3
>/dev/hde /dev/hdi /dev/hdk
>
>Running this command notifies me that there is an ext2 fs on one of
>the drives even if i fdisked them before and removed all partititions.
....
>Furthermore when i fdisk the drives after all of this i can see the 2
>partitions on /dev/hde and /dev/hdi but /dev/hdk shows that no
>partition exists. Is this a sign of data corruption or drive failure?
are you sure you removed all partitions before creating the md

>Shouldnt all 3 drives show the same partition information?
the drives should not contain any partition information.
(well actually the first will show an invalid partition table, since the
partition of the mdp array will be written exactly at the beginning of
the first raid disk.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
