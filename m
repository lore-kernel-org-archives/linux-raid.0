Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA115C46467
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 09:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjAOJjb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 04:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjAOJja (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 04:39:30 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCD8C156
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 01:39:29 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nvqqc4q28zXKm;
        Sun, 15 Jan 2023 10:39:19 +0100 (CET)
Message-ID: <67a93fbc-258a-4425-8fa3-6f40311bc864@thelounge.net>
Date:   Sun, 15 Jan 2023 10:39:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>, H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <37a150cb-286b-4137-bb72-08e2de21c851@youngman.org.uk>
 <9aab4088-3ba3-3c7c-4254-a0d829b06066@thelounge.net>
 <d9a4dea4-c15d-453d-9a60-4694e31147b1@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <d9a4dea4-c15d-453d-9a60-4694e31147b1@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 15.01.23 um 10:20 schrieb Wols Lists:
> On 15/01/2023 09:02, Reindl Harald wrote:
>>
> Reindl and me wind each other up, so watch out for a flame war :-)

yes, because you as usually don't get the point and when you say "My 
system is bios/grub" consider refrain talking about things you don't 
have see working in real life

that usually ends in unbacked theory helping nobody

the point is that "you need efi to boot, but the system can't access efi 
until it's booted" is nonsense because the whole point of the ESP is 
that the UEFI is driectly starting UEFI-binaries at the ESP

your UEFI bootloadr or even the plain kernel are just that: UEFI binaries

>> Am 15.01.23 um 09:41 schrieb Wols Lists:
>>> Are your /boot and /boot/efi using superblock 1.0? My system is 
>>> bios/grub, so not the same, but I use plain partitions here because 
>>> otherwise you're likely to get in a circular dependency - you need 
>>> efi to boot, but the system can't access efi until it's booted ... oops!
>> the UEFI don't care where the ESP is mounted later
>> from the viewpoint of the UEFI all paths are /-prefixed
>>
>> that's only relevant for the OS at the time of kernel-install / 
>> updates and the ESP is vfat and don't support RAID anyways
> 
> But ext4 doesn't support raid either. 

irrelevant - i am talking about THE ESP DO NOT SUPPORT RAID - 
filesystems don't need to support RAID because with your argumentation 
the tail is waving with the dog

> Btrfs, ZFS and XFS don't support 
> md-raid. That's the whole point of having a layered stack, rather than a 
> "one size fits all" filesystem.
> 
> IF YOU CAN GUARANTEE that /boot/efi is only ever modified inside linux

you can't

> then raid it. Why not? Personally, I'm not sure that guarantee holds.

and that's the problem

> Basically the rule is, if you want to access raid-ed linux partitions 
> outside of linux, you must be able to guarantee they aren't modified 
> outside of linux. And you have to use superblock 1.0. If you can't 
> guarantee both of those, don't go there

and hence don't go there

[root@srv-rhsoft:~]$ cat /etc/fstab | grep efi
UUID=87FD-D5DF  /efi  vfat 
defaults,discard,noatime,noexec,nosuid,nodev,noauto,umask=0022,gid=0,uid=0,x-systemd.automount,x-systemd.idle-timeout=60 
  0 1
UUID=8875-F946  /efi-bkp  vfat 
defaults,discard,noatime,noexec,nosuid,nodev,noauto,umask=0022,gid=0,uid=0,x-systemd.automount,x-systemd.idle-timeout=60 
  0 1



[root@srv-rhsoft:~]$ df
Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
/dev/md0       ext4   29G    8,9G   20G   31% /
/dev/md1       ext4  3,6T    2,1T  1,6T   57% /mnt/data
/dev/nvme0n1p1 f2fs  239G    9,7G  229G    5% /mnt/nvme
/dev/sda1      vfat  400M     69M  332M   18% /efi
/dev/sdb1      vfat  400M     69M  332M   18% /efi-bkp



[root@srv-rhsoft:~]$ ls /efi
insgesamt 68M
drwxr-xr-x 6 root root 8,0K 2022-11-16 18:18 EFI
drwxr-xr-x 2 root root 8,0K 2023-01-12 18:35 grub2
drwxr-xr-x 3 root root 8,0K 2023-01-14 21:13 loader
drwxr-xr-x 2 root root 8,0K 2022-10-20 14:34 sgdisk
-rwxr-xr-x 1 root root  16M 2023-01-11 11:53 
initramfs-6.0.18-200.fc36.x86_64.img
-rwxr-xr-x 1 root root  16M 2023-01-12 23:10 
initramfs-6.1.5-100.fc36.x86_64.img
-rwxr-xr-x 1 root root 246K 2023-01-07 18:28 config-6.0.18-200.fc36.x86_64
-rwxr-xr-x 1 root root 248K 2023-01-12 17:30 config-6.1.5-100.fc36.x86_64
-rwxr-xr-x 1 root root 6,9M 2023-01-07 18:28 
System.map-6.0.18-200.fc36.x86_64
-rwxr-xr-x 1 root root 5,8M 2023-01-12 17:30 
System.map-6.1.5-100.fc36.x86_64
-rwxr-xr-x 1 root root  13M 2023-01-07 18:28 vmlinuz-6.0.18-200.fc36.x86_64
-rwxr-xr-x 1 root root  13M 2023-01-12 17:30 vmlinuz-6.1.5-100.fc36.x86_64



[root@srv-rhsoft:~]$ ls /efi-bkp/
insgesamt 68M
drwxr-xr-x 6 root root 8,0K 2022-11-16 18:18 EFI
drwxr-xr-x 2 root root 8,0K 2023-01-12 18:35 grub2
drwxr-xr-x 3 root root 8,0K 2023-01-13 15:28 loader
drwxr-xr-x 2 root root 8,0K 2022-10-20 14:34 sgdisk
-rwxr-xr-x 1 root root  16M 2023-01-11 11:53 
initramfs-6.0.18-200.fc36.x86_64.img
-rwxr-xr-x 1 root root  16M 2023-01-12 23:10 
initramfs-6.1.5-100.fc36.x86_64.img
-rwxr-xr-x 1 root root 246K 2023-01-07 18:28 config-6.0.18-200.fc36.x86_64
-rwxr-xr-x 1 root root 248K 2023-01-12 17:30 config-6.1.5-100.fc36.x86_64
-rwxr-xr-x 1 root root 6,9M 2023-01-07 18:28 
System.map-6.0.18-200.fc36.x86_64
-rwxr-xr-x 1 root root 5,8M 2023-01-12 17:30 
System.map-6.1.5-100.fc36.x86_64
-rwxr-xr-x 1 root root  13M 2023-01-07 18:28 vmlinuz-6.0.18-200.fc36.x86_64
-rwxr-xr-x 1 root root  13M 2023-01-12 17:30 vmlinuz-6.1.5-100.fc36.x86_64



[root@srv-rhsoft:~]$ cat /scripts/backup-efi.sh
#!/usr/bin/bash
# Automounts triggern
ls /efi/ > /dev/null
ls /efi-bkp/ > /dev/null
# Sicherstellen dass "/efi" eingebunden ist
EFI_MOUNTED="$(mount | grep '/efi type' 2> '/dev/null' | grep 
'systemd.automount' | wc -l)"
if [ "$EFI_MOUNTED" == "0" ]; then
  echo "BACKUP-EFI: /efi nicht gemounted"
  logger --tag="BACKUP-EFI" "/efi nicht gemounted"
  exit 0
fi
# Sicherstellen dass "/efi-bkp" eingebunden ist
EFI_BKP_MOUNTED="$(mount | grep '/efi-bkp type' 2> '/dev/null' | grep 
'systemd.automount' | wc -l)"
if [ "$EFI_BKP_MOUNTED" == "0" ]; then
  echo "BACKUP-EFI: /efi-bkp nicht gemounted"
  logger --tag="BACKUP-EFI" "/efi-bkp nicht gemounted"
  exit 0
fi
# Boot-Umgebung auf zweite Festplatte sichern
echo "BACKUP-EFI: rsync --recursive --delete-after --times /efi/ /efi-bkp/"
logger --tag="BACKUP-EFI" "rsync --recursive --delete-after --times 
/efi/ /efi-bkp/"
if rsync --recursive --delete-after --times /efi/ /efi-bkp/; then
  echo "BACKUP-EFI: Erfolgreich"
  logger --tag="BACKUP-EFI" "Erfolgreich"
  ls -l -h -X --time-style=long-iso /efi-bkp/
else
  echo "BACKUP-EFI: FEHLGESCHLAGEN"
  logger --tag="BACKUP-EFI" "FEHLGESCHLAGEN"
fi
# Sicherstellen dass dieses Script niemals einen Fehler wirft
exit 0
