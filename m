From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Mon, 26 Sep 2016 11:42:14 +0800
Message-ID: <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/09/16 10:43, Benjammin2068 wrote:
> Hey all,
>
>
>  So the RAID5 which I upgraded to RAID6 was humming along all week just fine (I did the change last weekend) and this weekend I got this:
>
> WARNING: mismatch_cnt is not 0 on /dev/md127
>
> The array seems happy and clean:
>

You best find out what it is to start with. Example from mine :

brad@srv:~$ cat /sys/block/md2/md/mismatch_cnt
8171392

This is a bad example because it's a RAID10 of 6 SSDs. 3 support zero 
after TRIM and the other 3 don't, so after a TRIM of the filesystem the 
mismatch count is through the roof.

Unless you are swapping to an array or you have some known issue like 
the one I mention above, a mismatch count of non-zero is not good.

I lost most of a RAID6 due to a faulty SIL SATA controller and it was 
the high mismatch counts that alerted me. Unfortunately I was about 6 
months in and had only checked for the first time. It was silently 
corrupting reads under load, and so the read-modify-write cycles were 
quietly corrupting the array.

Check the mismatch count, run a "check" on the array and check it again. 
If they vary wildly something odd is going on. If they are the same then 
you might want to figure out what might have caused it.

Regards,
Brad.
