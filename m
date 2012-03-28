From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm raid6 recovery status
Date: Wed, 28 Mar 2012 20:39:22 +0100
Message-ID: <4F7368EA.9080600@anonymous.org.uk>
References: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>,<20120328151148.035bd737@notabene.brown> <B2B36B3006DB4C47A56D6BA19443F5D12DCEB63D@IU-MSSG-MBX110.ads.iu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB63D@IU-MSSG-MBX110.ads.iu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/03/2012 13:49, Paramasivam, Meenakshisundaram wrote:
> [root@in-rady-neuro9 ~]# df -kl /myarray
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/md2             11537161976    162432 10950945196   1% /myarray
> Should be 7TB of used space.

The device is showing as a 12TB array. Maybe fsck lost some of your data?

> [root@in-rady-neuro9 ~]# mdadm --detail /dev/md2
> /dev/md2:
>          Version : 0.90
>    Creation Time : Fri Dec 16 17:56:14 2011
>       Raid Level : raid6
>       Array Size : 11721086976 (11178.10 GiB 12002.39 GB)
>    Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)<<<====== Wrong! Should be 7TB of used array space.

No it shouldn't. Your component devices are indeed 2TB, and that is what 
is shown here.

md doesn't know how much data you have on the filesystem on top of the 
array.

Cheers,

John.
