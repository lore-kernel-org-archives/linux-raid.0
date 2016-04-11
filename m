From: Benjamin Meier <maillists@ferienwohnung-altenbeken.de>
Subject: Re: Recovery after failed chunk size change
Date: Mon, 11 Apr 2016 17:29:09 +0200
Message-ID: <570BC2C5.4070103@ferienwohnung-altenbeken.de>
References: <56FD7B92.1030102@ferienwohnung-altenbeken.de>
 <87a8ldrjcr.fsf@notabene.neil.brown.name>
 <56FED3F7.8080009@ferienwohnung-altenbeken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56FED3F7.8080009@ferienwohnung-altenbeken.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

>
> # Create a seven disk RAID6 array with sparse files (1GiB each)
> declare -a LO_DEVICES
> for x in 0 1 2 3 4 5 6; do
>   dd if=/dev/zero of=sparse$x bs=1G count=0 seek=1
>   losetup -f sparse${x}
>   LO_DEVICES[$x]=$(losetup -a|grep sparse${x}|cut -f1 -d" "|sed "s/://")
> done
> mdadm --create /dev/md/TestMD --chunk=4096 --bitmap=internal --level=6 
> --raid-devices=7 \
>   ${LO_DEVICES[*]}
> mdadm --wait /dev/md/TestMD
>
> # Provocate BUG.
> # Tested with Linux 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u4 
> (2016-02-29) x86_64 GNU/Linux
> #             mdadm - v3.3.2 - 21st August 2014
> mdadm --grow /dev/md/TestMD --chunk=64 --backup-file=backup.file
>

Was this issue reproducible? Or do you need any additional information?

I have discovered that the problem is not limited to changing the chunk 
size. It also happens with a RAID level change from say 6 to 5.

BR!
