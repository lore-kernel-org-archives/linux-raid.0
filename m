From: Phil Turmel <philip@turmel.org>
Subject: Re: raid10 recovery assistance requested
Date: Mon, 23 Sep 2013 00:12:26 -0400
Message-ID: <523FBFAA.3050705@turmel.org>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com> <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com> <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com> <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com> <523FBAB2.7070506@turmel.org> <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZke
 K-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZkeK-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/23/2013 12:04 AM, Dave Gomboc wrote:
>> Ok.  I can't determine how the superblocks ended up the way they did,
>> but the first two chunks appear to follow the proper patterns.
>>
>> I think you're best bet is to disconnect two of the drives, leaving one
>> that identifies as "0" and one that identifies as "3".
> 
> root@sysresccd /root % ls -l /dev/disk/by-id | grep Hitachi | grep -v part1
> lrwxrwxrwx 1 root root  9 Sep 22 20:17
> ata-Hitachi_HDS724040ALE640_PK1310PAG5ZY0J -> ../../sdb
> lrwxrwxrwx 1 root root  9 Sep 22 20:17
> ata-Hitachi_HDS724040ALE640_PK1310PAG62REJ -> ../../sdc
> lrwxrwxrwx 1 root root  9 Sep 22 20:17
> ata-Hitachi_HDS724040ALE640_PK1310PAG62T2J -> ../../sdd
> lrwxrwxrwx 1 root root  9 Sep 22 20:17
> ata-Hitachi_HDS724040ALE640_PK1311PAG4W5TS -> ../../sda
> root@sysresccd /root % cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md127 : inactive sdd1[3](S) sda1[0](S)
>       3907021954 blocks super 1.2
> 
> unused devices: <none>
> 
> Should I be disconnecting sdb and sdc, disconnecting sda and sdd, or
> does it matter?

Actually, from that report, just do "mdadm /dev/md127 --run".

> I should reboot using the rescue disk before attempting the forced
> assembly, not my boot drive, right?

Yes, but only necessary if the above fails.  And if there's a partial
assembly, you might need to use "mdadm --stop".

> Sorry if the answers to these questions seem obvious to you: I want to
> make sure that I understand you exactly.  I am moderately terrified at
> the moment.

You have duplicated the disks.  You have all of the insurance possible.

>> Then use "mdadm -Af /dev/mdX /dev/sdY1 /dev/sdZ1"
>>
>> The "-f" will force the assembly without regard to the event counts.
>> Then you can take a backup.  Finally you can add devices as "new" ones
>> to rebuild back to full redundancy.  (Fix your timeouts before
>> attempting the latter.)
> 
> When following up on your advice to search for those other terms, I
> saw several examples where people specified 7 seconds to the disk
> drive using that control program, and also read somewhere that while
> Linux's software raid will wait, that Linux's scsi subsystem has a 30
> second timeout.  So, 7 seconds sounds good?

Most traditional enterprise drives power up with t=7 seconds.  The SSDs
I've used use t=4 seconds.

Keep in mind that the setting is forgotten when the drive powers down.
You need the commands in rc.local or your distro's equivalent.

Phil

