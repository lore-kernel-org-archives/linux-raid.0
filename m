From: Andrew Rechenberg <arechenberg@shermfin.com>
Subject: Re: poor performance with raid1 / raid0
Date: 18 Jun 2003 09:42:23 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1055943743.31927.20.camel@cinshrlnxws01.shermfin.com>
References: <PERBUMSGID-ul6fzm7tvl3.fsf@ipchains.linpro.no>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <PERBUMSGID-ul6fzm7tvl3.fsf@ipchains.linpro.no>
To: Per Andreas Buer <perbu@linpro.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Check /proc/sys/dev/raid/speed_limit_[min|max].  If they are set too low
then your re-mirror will behave as such.  To change just echo a new
value:

echo 30000 > /proc/sys/dev/raid/speed_limit_min
echo 50000 > /proc/sys/dev/raid/speed_limit_max

Max is 100000 I believe.

Hope this helps,
Andy.

On Wed, 2003-06-18 at 08:32, Per Andreas Buer wrote:
> Hi.
> 
> I have two 70GB drives and a 140GB disk set up in RAID1 across the 140GB
> drive and a RAID0 built over the 70GB disks. Both the RAID0 and the big
> disk are quite fast (transfers ~ 110MB/s and 70MB/s) - but the mirror is
> dead slow.
> 
> Resync lokes like this: 
> 
> md1 : active raid1 md11[2] sdd1[0]
>       497856 blocks [2/1] [U_]
>       [=========>...........]  recovery = 48.0% (240188/497856)
>       finish=15.6min speed=272K/sec
> 
> If this configuration unwise in some respect?
> 
> Plain 2.4.20-kernel with some fixes (ext3 and ptrace bugs). Adaptec
> 7899P (rev 08).~
> 
> # cat /proc/scsi/scsi 
> Attached devices: 
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: IBM      Model: DDYS-T18350M     Rev: SA2A
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>   Vendor: FUJITSU  Model: MAN3735MC        Rev: 0109
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 02 Lun: 00
>   Vendor: FUJITSU  Model: MAN3735MC        Rev: 0109
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 03 Lun: 00
>   Vendor: SEAGATE  Model: ST3146807LC      Rev: 0004
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 06 Lun: 00
>   Vendor: SUPER    Model: GEM354 REV001    Rev: 1.04
>   Type:   Processor                        ANSI SCSI revision: 02
-- 
Andrew Rechenberg <arechenberg@shermfin.com>
Infrastructure Team, Sherman Financial Group
