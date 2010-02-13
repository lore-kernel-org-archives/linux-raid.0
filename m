From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Can this setup be saved?
Date: Sat, 13 Feb 2010 09:58:03 +0100
Message-ID: <4B76699B.5060202@texsoft.it>
References: <c98f60c41002121756j5e8cd32fwdc2cd22ba553d241@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c98f60c41002121756j5e8cd32fwdc2cd22ba553d241@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I've made a mess of my raid setup and am desperately trying to save
> it. The setup is RAID-5 on 3 SATA disks. Problems started with one of
> the disks getting unrecoverable read errors. Unfortunately I was away
> on a trip and the machine was used by my family while this was going
> on :(
>
> Array consists of three devices: /dev/sda2, /dev/sdc2, and /dev/sdd2.
> When I got back from the trip I found the following:
>
> 1. Two disks were removed from the array, leaving only /dev/sda2;
> 2. When either of the two was added, the array would start;
> 3. One combination of two disks (/dev/sda2 + /dev/sdd2) aproduced a
> running /dev/md0 with a proper ext3 filesystem seen on the drive (even
> passing fsck);
>
> At this point I added /dev/sdc2 and the reconstruction started.
> However did not complete, since /dev/sdd2 has unrecoverable errors.
> Reading the list archives I figured I need another drive to ddrescue
> /dev/sdd2, then perform the reconstruction.
>
> However at some point during/after the reconstruction the situation
> has changed. Now both /dev/sdc2 and /dev/sdd2 are marked as spare
> drives (see mdadm -E output below) and I cannot start the array. I
> think /dev/sdd2 should be in sync with /dev/sda2, but how can I bring
> it back (it used to be device 2)

I recently had similar problem with a 6 disk array, when one died and 
another gave read errors during reconstruction, this is my experience:

I was able to recover most data reassembling the array and copying data 
from it to another storage; I used a command like:

mdadm --create /dev/md3 --assume-clean --level=5 --raid-devices=6 
--spare-devices=0 /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdd4 /dev/sde4 missing


where /dev/sdf4 was the dead disk, which i left out as missing, and 
/dev/sdb4 was the one which gave read errors; missing a disk avoids 
starting the reconstruction.
It's important to set the md device in read-only mode (if supported by 
mdadm version can use the --readonly option directly with the  --create 
command, see man mdadm), and to mount the device readonly.

This mostly worked for me (lost 100Gb over 2.5Tb)

I hope you can recover your data.
Regards

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


