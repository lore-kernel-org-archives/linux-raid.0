From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Read data from disk that was part of RAID1 array
Date: Thu, 16 Mar 2017 23:31:37 +0100
Message-ID: <d0289a63-4aaf-a178-4fd9-dd8acf75c4e9@thelounge.net>
References: <008801d29ea3$3e858000$bb908000$@warren-selbert.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008801d29ea3$3e858000$bb908000$@warren-selbert.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <psangas@warren-selbert.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 16.03.2017 um 23:18 schrieb Peter Sangas:
> My setup:
>
> Linux green 4.4.0-47-generic #68-Ubuntu SMP Wed Oct 26 19:39:52 UTC 2016
> x86_64 x86_64 x86_64 GNU/Linux
> Ubuntu 16.04.2 LTS
>
> mdadm -V
> mdadm - v3.3 - 3rd September 2013
>
>
> I have only one disk from a RAID1 array and I would like to read data from
> one of the partitions.  This there a way to mount this and read the data?

you only need one disk to start a RAID1
RAID1 are ust mirrors

just assemble the RAID1 or most likely you can mount the partitions as 
they are
