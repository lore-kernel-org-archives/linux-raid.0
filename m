From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID5 grow interrupted.
Date: Thu, 22 Sep 2016 16:18:06 +0100
Message-ID: <57E3F62E.10706@youngman.org.uk>
References: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <36947ef9-64e2-f084-4949-476107e2771e@spallek.org>
Sender: linux-raid-owner@vger.kernel.org
To: Axel Spallek <axel@spallek.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/09/16 15:11, Axel Spallek wrote:
> The server came up again, but without /dev/md1.
> 
> I had made a Backup, which is 2 days old. Not so bad, because I have the
> seafile data on several computers. But to get the RAID back to work
> would be better.
> 
> How do I restart the rebuild process with the backup-file?
> 
> This is what I get in the console:
> 
> root@s10:~# cat /proc/mdstat
> Personalities :
> md1 : inactive sdh1[0](S) sda1[5](S) sdb1[6](S) sdc1[7](S) sdd1[8](S)
> sdf1[4](S) sde1[2](S) sdg1[1](S)
>       31255059140 blocks super 1.2
> 
> unused devices: <none>

Okay, quick response here. Won't do any damage, might work.

Stop and reassemble the array ...

mdadm --stop /dev/md1

mdadm --assemble --scan

What you describe sounds like something tried to start the array while
it was half-assembled. There's a bunch of interactions between udev,
systemd, and mdadm, which seem to get badly off-kilter if something
hiccups anywhere.

My suggestion won't do any harm - it might fix the problem, and it'll
give the experts the chance to chime in.

Cheers,
Wol
