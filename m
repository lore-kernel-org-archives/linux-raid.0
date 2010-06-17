From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 17:25:03 -0500
Message-ID: <4C1AA0BF.6030300@gmail.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>    <20100617100109.32a20ffa@natsu>    <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>    <20100617221300.3e30afe0@natsu> <4C1A50FA.50504@stud.tu-ilmenau.de> <38599704579ec5d844bada876838dda7.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38599704579ec5d844bada876838dda7.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/17/2010 02:51 PM, aragonx@dcsnow.com wrote:
>> Actually, you have not said a word about which controllers you use (for
>> the drives).  Using the wrong controller can drain speed a lot.  As from
>> the kernel benchmarks it seems like neither RAM nor computing power are
>> the bottlenecks.
>>
>> Some SATA-controllers handle "nearly parallel" writes to multiple drives
>> better than others.  SiI products for example have a noticeable drop-off
>> for each disk you add.  Pretty late Intels nearly show no impact of many
>> disks in parallel.  So maybe that could be the topic you should be
>> after.  (And maybe a lspci could help :)
>>
>> Stefan
>
> Hi Stefan,
>
> Here is the output of lspci.  There are 5 disks on the ATI controller.
> Four of them are part of the RAID.  The last disk is on the JMicron
> controller which is a PCIE-1x card.  I can move one more disk to the
> JMicron controller if you think that would help.  Or just purchase a new 4
> port controller?
>
> lspci|grep SATA
> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller
> [IDE mode]
> 02:00.0 SATA controller: JMicron Technologies, Inc. 20360/20363 Serial ATA
> Controller (rev 03)
>
> ---
> Will Y.
>
>

[IDE mode] is probably a bad idea...a bios setting will change that.

Mine shows this:

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA 
Controller [AHCI mode]

And my results on similar test show this (3x500gb raid5), single disk 
shows this speed, so raid write speed breaks down to about 60-70% of 
single disk speed:
dd if=/dev/sdb of=/dev/null bs=1M count=2048
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 28.8118 s, 74.5 MB/s


dd if=/dev/zero of=zerofile bs=1M count=2048 conv=fdatasync,notrunc
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 36.6523 s, 58.6 MB/s

dd if=/dev/zero of=zerofile bs=1M count=6144 conv=fdatasync,notrunc
6144+0 records in
6144+0 records out
6442450944 bytes (6.4 GB) copied, 113.893 s, 56.6 MB/s

dd if=/dev/zero of=zerofile bs=1M count=16384 conv=fdatasync,notrunc
^C15006+0 records in
15006+0 records out
15734931456 bytes (16 GB) copied, 277.814 s, 56.6 MB/s

And this for reads:
dd if=zerofile of=/dev/null bs=1M count=6144 conv=fdatasync,notrunc
6144+0 records in
6144+0 records out
6442450944 bytes (6.4 GB) copied, 53.8029 s, 120 MB/s



