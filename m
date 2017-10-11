From: Joseba Ibarra <wajalotnet@gmail.com>
Subject: Re: Can't mount /dev/md0 Raid5
Date: Wed, 11 Oct 2017 13:14:33 +0200
Message-ID: <59DDFD19.1040700@gmail.com>
References: <59DDF18A.9060800@gmail.com> <8628ddba-8cec-24d8-e07a-195d47f579be@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8628ddba-8cec-24d8-e07a-195d47f579be@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Rudy

1- Yes, with all 4 disk plugged in, system does not boot
2- Yes, with the broken disk unplugged, it boots
3 - Yes, raid does not assemble during boot. I assemble manually doing

root@grafico:/home/jose# mdadm --assemble --scan /dev/md0
root@grafico:/home/jose# mdadm --assemble --scan
root@grafico:/home/jose# mdadm --assemble /dev/md0

4 -When I try to mount

   mount /dev/md0 /mnt

mount: wrong file system, bad option, bad superblock in /dev/md0, 
missing codepage or helper program, or other error

     In some cases useful info is found in syslog - try dmesg | tail or 
something like that.

I do dmesg | tail

root@grafico:/mnt# dmesg | tail
[  705.021959] md: pers->run() failed ...
[  849.719439] EXT4-fs (md0): unable to read superblock
[  849.719564] EXT4-fs (md0): unable to read superblock
[  849.719589] EXT4-fs (md0): unable to read superblock
[  849.719616] UDF-fs: error (device md0): udf_read_tagged: read failed, 
block=256, location=256
[  849.719625] UDF-fs: error (device md0): udf_read_tagged: read failed, 
block=512, location=512
[  849.719638] UDF-fs: error (device md0): udf_read_tagged: read failed, 
block=256, location=256
[  849.719642] UDF-fs: error (device md0): udf_read_tagged: read failed, 
block=512, location=512
[  849.719643] UDF-fs: warning (device md0): udf_fill_super: No 
partition found (1)
[  849.719667] isofs_fill_super: bread failed, dev=md0, iso_blknum=16, 
block=32

Thanks a lot for your helping
> Rudy Zijlstra <mailto:rudy@grumpydevil.homelinux.org>
> 11 de octubre de 2017, 12:42
> Hi Joseba,
>
>
>
> Let me see if i understand you correctly
>
> - with all 4 disks plugged in, your system does not boot
> - with the broken disk unplugged, it boots (and from your description 
> it is really broken, no DISK recovery possible unless by specialised 
> company)
> - raid does not get assembled during boot, you do a manual assembly?
>      -> please provide the command you are using
>
> from the log above, you should be able to do a mount of /dev/md0 which 
> would auto-start the raid.
>
> If that works, the next step would be to check the health of the other 
> disks. smartctl would be your friend.
> Another useful action would be to copy all important data to a backup 
> before you add a new disk to replace the failed disk.
>
> Cheers
>
> Rudy
