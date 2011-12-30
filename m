From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: RAID5 alignment issues with 4K/AF drives (WD green ones)
Date: Fri, 30 Dec 2011 14:24:40 +0800
Message-ID: <4EFD5928.100@fnarfbargle.com>
References: <A0933627-0D84-496C-B7B7-4FE265C2A212@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A0933627-0D84-496C-B7B7-4FE265C2A212@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michele Codutti <codutti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/12/11 07:28, Michele Codutti wrote:
> Hi all, I'm writing to this mailing list because I cannot figure out why I had some performance issues with my three WD20EARS (2TB Western Digital "Green" 4K/AF drive).
> These drives has a (sequential) write throughput around 100MB/s. When I combine them in a RAID0 configuration the throughput is around 300 MB/s and in a RAID1 configuration they preserve a single drive performance of 100MB/s.
> When I combine all three drives in a RAID5 configuration the (individual) performance falls around 40MB/s.
> I get the same performance level when I do individual misaligned writes (ex: dd if=/dev/zero bs=6K of=/dev/sda).
> The drives are not partitioned. I'm using the default chunk size (512K) and the default metadata superblock version (1.2).
> I had not formatted the RAID or any single drive during my test i had directly used the raw devices.
> I'm using a 11.10 ubuntu with 3.0.0 linux kernel and 3.1.4 mdadm.
> The hardware is a HP microserver.
>
Just a thought, but do you have the "XP mode" jumper removed on all drives?

Regards,
Brad
