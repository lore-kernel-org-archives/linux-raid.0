Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4ED2202961
	for <linux-raid@vger.kernel.org>; Mon, 20 Oct 2025 19:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760988146; cv=none; b=AJk390uSyZVZvWS6Lehh4Jq1wdQW3L/v1Atu/coQSCrbZFkruyclIAjQFvQae8XNXYMmH6q85sYUYYgI8oJrlnMrLKjQutRda79dhlhbNOCeAFbtsD0S3J9VrR21PWiB5HCj45zYtIpSFYPnurTq8yBkgWwheFzehhmVzDLYgsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760988146; c=relaxed/simple;
	bh=603v9cskmRtsuxeTo2cfG1tnLXMTkY4a9YeLR6eQLW0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ERRK8TQ4JGptl+lbY7WjbFm2SFbx7n4JgTx9j0KWAR0aXhJYmgbAfGZfhj0UWxtGi1WZXkM+XmHBRXiw7ub5SDdl7jUaJIZxmle7k8ABsS0DbMb+N1Vdj0Vri0c4Q+/otMPOTRLwZYlzCAD8n7qCcH0+hYn4VyDCPcx6+EgTqc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THPmJn6N; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THPmJn6N"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ecdf2b1751so2676103f8f.0
        for <linux-raid@vger.kernel.org>; Mon, 20 Oct 2025 12:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760988143; x=1761592943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qr99Ah18AIGdsamz0/TjrBJ7CODaSnEB08mK1wxGu18=;
        b=THPmJn6NG/bdrBVia0+zT8Kb1hjGJdMG/CaUwKhQ6qDBFw5x8ilJ61g3K/ze15Pmfu
         L0EMD+FEfupKcDccROM4fy8tmJWf0hc9RMUQDQj6Pk3ynxaYhm4678CZq3jvRg2VvYG9
         +gOpCMuufdZvMC/azbR/6hmpb8qtq0X6owE1HQqdsMsqnZiD+ThaPeKJ+XtyJye5K8vS
         FzxqeOdSO0it+SiN65+bF5G8g9Kfj3HYgtlgKaQu7nyciijW+QKb3I9rQR01HDqxshpM
         F+lQOcnbtNHTxfpfPGY0wxjwYa45OMDfCNr5uiODgUEeBMRg9GIlNBrbWaEfIN84vKwp
         29ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760988143; x=1761592943;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qr99Ah18AIGdsamz0/TjrBJ7CODaSnEB08mK1wxGu18=;
        b=SekBUky24DgnLpUlehSDQ4UEWoP5JAx5KbhsH3PEQm1b1j6GzesZkdir3nIZbL3bZJ
         XqKAkHdkLkDVMOkWii5oHAOZIfAMbjHdi5zn4mLY+dYpqaHAkAHO85ltWOwTIgpBy5to
         z7SlpW4Ey1VKb4n3oi4XshvNMYMno7UcKl6kLT7gX8FUfttCO9DiGidTmI1iGJxC1h3Q
         e90feOVfNyJzY+SQxY2sJats2i/18FGjTMOsb8Zp9CIVNfdBgDuZgZxjvE5UJVNVHC9V
         6w+577xSeSbVvA+zSK5u3iEPqrkfppAfYI9GJopGLq9yIqH+GdNST5rsLhp2u70cyY7e
         AQkg==
X-Gm-Message-State: AOJu0Yy2sCzjo2d/P1m8Bm/00pKA/huYaYBGh8SCsOnCQJF5quzvb9KT
	4aamnxg/gw69egjhPyoOwHodketP8Fgs3L+N7T2GVubPbCwyUsFviBtU
X-Gm-Gg: ASbGnct/JBQjsLcjOJuZwfgy7iNRJnaHDWgol36AGV0UuPAJkWEhkQHo11tRo3ZDmYg
	bJOtW9OrRd1kLXX1eO3zmPKHOYygtmTvGDHkOQKl0ciRmHsmWNczIwyjoMI/UauNVIj4Az67Ufi
	c2JAccN0ng4h8ev0+883YmlYZsOkPBXSreWBRM/C5/NpCYk4a7OwqjZTzNviLF+8Ax349V9UnkD
	H+VPyqfW1Hfm6Nc1aHTPPxIlzQ7TysG8/AjIO3I9oqyvCpJc/39Li9vCmzdnoGWlOyAPQC3H4jf
	RVVpxmMsffAm7XUaqoUrC2NjNSGNjs1roS2UAk9WnQW0StoPth1dm9Ac0I3b7yUC/KhD0oujQNX
	ZQAiL6Nzh6n7+t7eHGaUYAM58OTqd7qVYmpZNJxkD5Zzwsq/efgRKV5Ykc4dATRV/dsT45LbUfj
	dDxN9YfpaPM9DHRlBtdOcWRVpdacHAPa2xMQ==
X-Google-Smtp-Source: AGHT+IGU4YHJv0UOL0fphnSmqTTLLoZZWwfMV4YZSyBzJXcZdaa81fNdoYizZVpuLrWDlWkEfloSyA==
X-Received: by 2002:a05:6000:2287:b0:3d1:8d1e:8e9 with SMTP id ffacd0b85a97d-42704d94472mr9665784f8f.32.1760988142515;
        Mon, 20 Oct 2025 12:22:22 -0700 (PDT)
Received: from [192.168.0.3] (mob-5-90-140-67.net.vodafone.it. [5.90.140.67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a96asm16759203f8f.31.2025.10.20.12.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 12:22:21 -0700 (PDT)
Message-ID: <b0db39dc-f261-4bc3-aac3-e983150ba8c7@gmail.com>
Date: Mon, 20 Oct 2025 21:22:19 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Franco Martelli <martellif67@gmail.com>
Subject: Re: Unable to set group_thread_cnt using mdadm.conf
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, mtkaczyk@kernel.org
References: <608328b7-9dfe-4edd-afd5-68366fb845bc@gmail.com>
 <CALTww2_0rAvqc=C0zAP7pdGT-V7-ypMV5Rc=dk4iKS4VkAVE7Q@mail.gmail.com>
Content-Language: en-US
Autocrypt: addr=martellif67@gmail.com; keydata=
 xjMEXwx9ehYJKwYBBAHaRw8BAQdA8CkGKYFI/MK9U3RPhzE5H/ul7B6bHu/4BIhTf6LLO47N
 J0ZyYW5jbyBNYXJ0ZWxsaSA8bWFydGVsbGlmNjdAZ21haWwuY29tPsKWBBMWCAA+FiEET9sW
 9yyU4uM6QbloXEn0O0LcklAFAmhyroACGwMFCQ0ncuYFCwkIBwIGFQoJCAsCBBYCAwECHgEC
 F4AACgkQXEn0O0LcklAHVwD9H5JZ52g292FD8w0x6meDD8y/6KkNpzuaLHP6/Oo8kAIBAJsh
 aMB9LdCBJTMtnxU8JTHtAoGOZ/59UJWeZIkuWJUNzjgEXwx9ehIKKwYBBAGXVQEFAQEHQNP5
 V2q0H0oiJu89h1SSPgQDtkixXvUvRf1rNLLIcNpPAwEIB8J+BBgWCAAmFiEET9sW9yyU4uM6
 QbloXEn0O0LcklAFAmhyroACGwwFCQ0ncuYACgkQXEn0O0LcklASVwEAoEkHMEU7mHc0zmAu
 D2R1PYsDh9+3wQeied5PrF+HdakBAOeSGsf40GBew5umZuM59I04d1uXYAXGMP+jGN2RUtMA
In-Reply-To: <CALTww2_0rAvqc=C0zAP7pdGT-V7-ypMV5Rc=dk4iKS4VkAVE7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/10/25 at 16:40, Xiao Ni wrote:
> On Fri, Oct 17, 2025 at 10:07 PM Franco Martelli <martellif67@gmail.com> wrote:
>>
>> Hello,
>>
>> I've a RAID5 array on Debian 13:
>>
>> ~$ cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4] [linear] [raid0] [raid1] [raid10]
>> md0 : active raid5 sda1[0] sdc1[2] sdd1[3](S) sdb1[1]
>>         1953258496 blocks super 1.2 level 5, 512k chunk, algorithm 2
>> [3/3] [UUU]
>>
>> unused devices: <none>
>>
>> ~# mdadm --version
>> mdadm - v4.4 - 2024-11-07 - Debian 4.4-11
>>
>> the issue is that I can't set group_thread_cnt if I use the syntax
>> described in mdadm.conf(5) man-page:
>>
>> …
>> SYSFS name=/dev/md/raid5 group_thread_cnt=4 sync_speed_max=1000000
>> SYSFS uuid=bead5eb6:31c17a27:da120ba2:7dfda40d group_thread_cnt=4
>> sync_speed_max=1000000
>>
>> my "mdadm.conf" is:
>>
>> ~$ grep -v '^#' /etc/mdadm/mdadm.conf
>>
>>
>> HOMEHOST <system>
>>
>> MAILADDR root
>>
>> ARRAY /dev/md/0  metadata=1.2 UUID=8bdf78b9:4cad434c:3a30392d:8463c7e0
>>      spares=1
>>
>>
>> SYSFS name=/dev/md/0 group_thread_cnt=8
>> SYSFS uuid=8bdf78b9:4cad434c:3a30392d:8463c7e0 sync_speed_max=1000000
>>
>>
>> after I makes changes to the file "mdadm.conf" I rebuild the initramfs
>> image file and reboot. The thing that seems strange to me is that the
>> other item I set (sync_speed_max) is changed accordingly, only
>> "group_thread_cnt" fails to set (it's always ==0):
>>
>> ~$ cat /sys/block/md0/md/group_thread_cnt
>> 0
>> ~$ cat /sys/block/md0/md/sync_speed_max
>> 1000000 (system)
>>
>> Why "sync_speed_max" is set while "group_thread_cnt" it is not? Any clue?
> 
> Hi Franco
> 
> The sync_speed_max should not be set too. Because it still shows
> "system" rather than "local". I tried in my environment. It indeed has
> a problem if you specify uuid in conf file to set sysfs value. This is
> my conf:

Hi Xiao,

Yes, it's correct, I cannot set sync_speed_max maybe it reflects the 
setting of:

~$ cat /etc/sysctl.d/md0.conf
dev.raid.speed_limit_max = 1000000

I don't know, I guess…

> 
> cat /etc/mdadm.conf
> ARRAY /dev/md/0  metadata=1.2 UUID=689642b7:fa1e5cf2:82c6c527:ca37716f
> SYSFS name=/dev/md/0 sync_speed_max=5000 group_thread_cnt=8
> 
> After assembling by command `mdadm -As`:
> [root@ mdadm]# cat /sys/block/md0/md/group_thread_cnt
> 8
> [root@ mdadm]# cat /sys/block/md0/md/sync_speed_max
> 5000 (local)
> 
> If I specify uuid in the second line of the conf file, it can't work.
> Because the uuid read from the device doesn't match with the conf
> file. It should be the problem of big-endian and little-endian. I'm
> looking at this problem.
> 
> But in your conf, the group thread cnt should be set successfully.
> What's your command to assemble the array? Can you stop the array and
> assemble it after boot.

my mdadm.conf now is:

~$ grep -v '^#' /etc/mdadm/mdadm.conf


HOMEHOST <system>

MAILADDR root

ARRAY /dev/md/0  metadata=1.2 UUID=8bdf78b9:4cad434c:3a30392d:8463c7e0
    spares=1


SYSFS name=/dev/md/0 sync_speed_max=5000000 group_thread_cnt=8


I rebuild the initramfs image file:

~# update-initramfs -uk all
update-initramfs: Generating /boot/initrd.img-6.12.48+deb13-amd64
update-initramfs: Generating /boot/initrd.img-6.12.48


mdadm files in the initramfs file are:

~# lsinitramfs /boot/initrd.img-6.12.48 |grep mdadm
etc/mdadm
etc/mdadm/mdadm.conf
etc/modprobe.d/mdadm.conf
scripts/local-block/mdadm
scripts/local-bottom/mdadm
usr/sbin/mdadm


and then I rebooted the system, I cannot set group_thread_cnt:

~$ cat /sys/block/md0/md/sync_speed_max
1000000 (system)
~$ cat /sys/block/md0/md/group_thread_cnt
0


I cannot stop the array since my root filesystem resides on it. The 
command that Debian 13 Trixie uses to assemble the array is:

~$ ps -wax|grep mdadm
     543 ?        Ss     0:00 /usr/sbin/mdadm --monitor --scan


FYI the topology of the storage on my system is:

PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices, Inc. 
[AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
├scsi 0:0:0:0 ATA      ST1000DM003-1CH1 {Z1D93ZHJ}
│└sda 931.51g [8:0] Partitioned (dos)
│ └sda1 931.51g [8:1] MD raid5 (0/3) (w/ sdd1,sdc1,sdb1) in_sync 
'itek:0' {8bdf78b9-4cad-434c-3a30-392d8463c7e0}
│  └md0 1.82t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk 
{8bdf78b9:-4cad-43:4c-3a30-:392d8463c7e0}
│   │               PV LVM2_member 1,82t used, 0 free 
{6HMlpl-ZLKi-4JOP-DU9i-aiZh-7IoH-Dd1Hoy}
│   └VG ld0 1,82t 0 free {BUUpNE-w0IY-Ut2I-OmiZ-err7-zXLX-F0VmjU}
│    ├dm-6 1.67t [253:6] LV data ext4 {29ed4bd3-f546-4781-988c-39f853276492}
│    ├dm-1 27.94g [253:1] LV lv1 ext4 {fa251689-956d-4a3c-b60c-0ab92ac51488}
│    ├dm-2 27.94g [253:2] LV lv2 ext4 {4baf8453-6525-4b72-aade-25de240ac4f4}
│    ├dm-3 27.94g [253:3] LV lv3 ext4 {9ad082fd-d9fb-4ddc-b3e8-a39753480319}
│    │└Mounted as /dev/mapper/ld0-lv3 @ /
│    ├dm-4 27.94g [253:4] LV lv4 ext4 {6cbd93ab-0def-4a56-8270-176c66588c45}
│    ├dm-5 27.94g [253:5] LV lv5 ext4 {665d8145-786a-461b-a4c1-7155156c40be}
│    └dm-0 9.31g [253:0] LV swap swap {f3859a53-eb70-4a7b-ac94-93433b72a723}
├scsi 1:0:0:0 ATA      ST1000DM003-1CH1 {Z1D8ZJ1H}
│└sdb 931.51g [8:16] Partitioned (dos)
│ └sdb1 931.51g [8:17] MD raid5 (1/3) (w/ sdd1,sdc1,sda1) in_sync 
'itek:0' {8bdf78b9-4cad-434c-3a30-392d8463c7e0}
│  └md0 1.82t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk 
{8bdf78b9:-4cad-43:4c-3a30-:392d8463c7e0}
│                   PV LVM2_member 1,82t used, 0 free 
{6HMlpl-ZLKi-4JOP-DU9i-aiZh-7IoH-Dd1Hoy}
├scsi 2:0:0:0 ATA      ST1000DM003-1CH1 {Z1D94DF3}
│└sdc 931.51g [8:32] Partitioned (dos)
│ └sdc1 931.51g [8:33] MD raid5 (2/3) (w/ sdd1,sdb1,sda1) in_sync 
'itek:0' {8bdf78b9-4cad-434c-3a30-392d8463c7e0}
│  └md0 1.82t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk 
{8bdf78b9:-4cad-43:4c-3a30-:392d8463c7e0}
│                   PV LVM2_member 1,82t used, 0 free 
{6HMlpl-ZLKi-4JOP-DU9i-aiZh-7IoH-Dd1Hoy}
├scsi 3:0:0:0 ATA      ST1000DM003-1CH1 {Z1D94DF5}
│└sdd 931.51g [8:48] Partitioned (dos)
│ └sdd1 931.51g [8:49] MD raid5 (none/3) (w/ sdc1,sdb1,sda1) spare 
'itek:0' {8bdf78b9-4cad-434c-3a30-392d8463c7e0}
│  └md0 1.82t [9:0] MD v1.2 raid5 (3) clean, 512k Chunk 
{8bdf78b9:-4cad-43:4c-3a30-:392d8463c7e0}
│                   PV LVM2_member 1,82t used, 0 free 
{6HMlpl-ZLKi-4JOP-DU9i-aiZh-7IoH-Dd1Hoy}
└scsi 4:0:0:0 ASUS     BW-16D1HT        {K9GDBBA5248}
  └sr0 1.00g [11:0] Empty/Unknown
PCI [ahci] 04:00.0 SATA controller: ASMedia Technology Inc. ASM1062 
Serial ATA Controller (rev 01)
└scsi 5:x:x:x [Empty]


Thank you again, kind regards.
-- 
Franco Martelli
