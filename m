From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Mon, 26 Sep 2016 02:19:33 -0500
Message-ID: <4118791e-e1d8-1261-2920-560f22ec7b6f@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 09/25/2016 10:42 PM, Brad Campbell wrote:
>
> You best find out what it is to start with. Example from mine :
>
> brad@srv:~$ cat /sys/block/md2/md/mismatch_cnt
> 8171392
>
> This is a bad example because it's a RAID10 of 6 SSDs. 3 support zero after TRIM and the other 3 don't, so after a TRIM of the filesystem the mismatch count is through the roof.
>
> Unless you are swapping to an array or you have some known issue like the one I mention above, a mismatch count of non-zero is not good.
>
> I lost most of a RAID6 due to a faulty SIL SATA controller and it was the high mismatch counts that alerted me. Unfortunately I was about 6 months in and had only checked for the first time. It was silently corrupting reads under load, and so the read-modify-write cycles were quietly corrupting the array.
>
> Check the mismatch count, run a "check" on the array and check it again. If they vary wildly something odd is going on. If they are the same then you might want to figure out what might have caused it.

Mine is 8.

besides moving from a RAID5 to a RAID6, I also recently installed a new HD controller (Marvell 88SE9485) from SuperMicro. (onto a SuperMicro Motherboard)

Previously, the RAID was contained with 4 SATA ports all on the motherboard (also SuperMicro) -- only with this move to RAID6, I needed the extra ports, so this is the card I got.

I'll go run a check (and repair)...

Will report back when it's all done.

 -Ben
