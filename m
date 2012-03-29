From: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Subject: RE: mdadm raid6 recovery status
Date: Thu, 29 Mar 2012 18:47:14 +0000
Message-ID: <B2B36B3006DB4C47A56D6BA19443F5D12DCEBAA4@IU-MSSG-MBX110.ads.iu.edu>
References: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>
	<20120328151148.035bd737@notabene.brown>
	<B2B36B3006DB4C47A56D6BA19443F5D12DCEB63D@IU-MSSG-MBX110.ads.iu.edu>,<20120329102704.14b08f2a@notabene.brown>,<B2B36B3006DB4C47A56D6BA19443F5D12DCEBA2E@IU-MSSG-MBX110.ads.iu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B2B36B3006DB4C47A56D6BA19443F5D12DCEBA2E@IU-MSSG-MBX110.ads.iu.edu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Clarification:
>>should I do new array creation 
I meant running newfs on assembled 12 TB array, and restore data from backup, to resolve "df" reporting problem.

________________________________________
From: Paramasivam, Meenakshisundaram
Sent: Thursday, March 29, 2012 1:33 PM
To: NeilBrown
Cc: linux-raid@vger.kernel.org
Subject: RE: mdadm raid6 recovery status

Good news: Got ALL of our data back. [Actually it was 4.96TB not 7TB].
                     mdadm is a good one.

Bad news: "df" is reporting wrong, while "du" is showing full size.
# df -kl /myarray
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md2             11537161976    162432 10950945196   1% /myarray
# du -sk /myarray
5326133556      /myarray
#

I never looked into du or looked in depth of the files & folders and simply got mislead by reported "df" usage; data was there all along. We definitely want "df" for the array's filesystem (ext3) to report right.

Now that we are backing up all of the data (at 400 Mbps) over network, I want to know if "df" reporting can be fixed easily or should I do new array creation and restore data from backup.

We are ordering a new RAID card, just to be on safer side.

Sundar

________________________________________
From: NeilBrown [neilb@suse.de]
Sent: Wednesday, March 28, 2012 7:27 PM
To: Paramasivam, Meenakshisundaram
Cc: linux-raid@vger.kernel.org
Subject: Re: mdadm raid6 recovery status

On Wed, 28 Mar 2012 12:49:18 +0000 "Paramasivam, Meenakshisundaram"
<mparamas@iupui.edu> wrote:

> [root@in-rady-neuro9 ~]# df -kl /myarray
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md2             11537161976    162432 10950945196   1% /myarray
> Should be 7TB of used space.

This is bad.  Something has happened to your filesystem.
It is almost as though someone ran "mkfs" on the array.
I don't know much about recovery after such an action, but I doubt you
will get much back.

>
> [root@in-rady-neuro9 ~]# cat /proc/partitions
> major minor  #blocks  name
>
>    8        0  438960128 sda
>    8        1     512000 sda1
>    8        2   51200000 sda2
>    8        3  387247104 sda3
>    8       16 1953514584 sdb
>    8       32 1953514584 sdc
>    8       48 1953514584 sdd
>    8       64 1953514584 sde
>    8       80 1953514584 sdf
>    8       96 1953514584 sdg
>    8      112 1953514584 sdh
>    8      128 1953514584 sdi
>  253        0  346226688 dm-0
>  253        1   40992768 dm-1

No md2 ???

>
> sd[b-i] are raid devices
>
> [root@in-rady-neuro9 ~]# mdadm --detail /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Fri Dec 16 17:56:14 2011
>      Raid Level : raid6
>      Array Size : 11721086976 (11178.10 GiB 12002.39 GB)
>   Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)  <<<====== Wrong! Should be 7TB of used array space.

"Used Dev Size" isn't "how much of the array is used by the filesystem" -
mdadm doesn't know anything about filesystems.
It is "How much of each individual device is used by the array", which is
usually a little less than the size of the smallest device.
So 2TB is correct here.


NeilBrown


