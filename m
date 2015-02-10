From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Wierd: Degrading while recovering raid5
Date: Tue, 10 Feb 2015 18:35:09 +1100
Message-ID: <54D9B4AD.8010204@websitemanagers.com.au>
References: <CAP7a4UQCB=jdf7=sz8MoYL+WGbMbT_09_xL460DLX-epLAS0Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAP7a4UQCB=jdf7=sz8MoYL+WGbMbT_09_xL460DLX-epLAS0Sw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Logue <teque5@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Kyle,

There are other people who will jump in and help you with your problem, 
but I'll add a couple of pointers while you are waiting. See below.

On 10/02/15 15:20, Kyle Logue wrote:
> Hey all:
>
> I have a 5 disk software raid5 that was working fine until I decided
> to swap out an old disk with a new one.
>
> mdadm /dev/md0 --add /dev/sda1
> mdadm /dev/md0 --fail /dev/sde1
>
> At this point it started automatically rebuilding the array.
> About 60%? of the way in it stops and I see a lot of this repeated in my dmesg:
>
> [Mon Feb  9 18:06:48 2015] ata5.00: exception Emask 0x0 SAct 0x0 SErr
> 0x0 action 0x6 frozen
> [Mon Feb  9 18:06:48 2015] ata5.00: failed command: SMART
> [Mon Feb  9 18:06:48 2015] ata5.00: cmd
> b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 7
> [Mon Feb  9 18:06:48 2015]          res
> 40/00:ff:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
> [Mon Feb  9 18:06:48 2015] ata5.00: status: { DRDY }
> [Mon Feb  9 18:06:48 2015] ata5: hard resetting link
> [Mon Feb  9 18:06:58 2015] ata5: softreset failed (1st FIS failed)
> [Mon Feb  9 18:06:58 2015] ata5: hard resetting link
> [Mon Feb  9 18:07:08 2015] ata5: softreset failed (1st FIS failed)
> [Mon Feb  9 18:07:08 2015] ata5: hard resetting link
> [Mon Feb  9 18:07:12 2015] ata5: SATA link up 1.5 Gbps (SStatus 113
> SControl 310)
> [Mon Feb  9 18:07:12 2015] ata5.00: configured for UDMA/33
> [Mon Feb  9 18:07:12 2015] ata5: EH complete
>
> ata5 corresponds to my /dev/sdc drive.
First, check if the drive is faulty.
dd if=/dev/sdc of=/dev/null bs=10M

If that completes without any errors from dd, then the drive can be read 
OK. Now check the logs, was there any errors there? Especially if there 
were errors in the logs, (or even if not) read about timing mismatches 
between the kernel and the hard drive, and how to solve that. There was 
another post earlier today with some links to specific posts that will 
be helpful (check the online archive).

Finally, I think your first mistake was to fail the drive. You should 
have replaced it which will stop you from losing protection from a 
failed drive.
See the second answer to this question:
http://unix.stackexchange.com/questions/74924/how-to-safely-replace-a-not-yet-failed-disk-in-a-linux-raid5-array

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
