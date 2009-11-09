From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Sun, 8 Nov 2009 21:45:40 -0500
Message-ID: <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com>
	 <4AF6D5FD.2010602@gmail.com> <4AF70791.9080007@sauce.co.nz>
	 <4AF741A9.80701@gmail.com> <4AF74D39.3000304@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF74D39.3000304@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is interesting to hear as I have been using smartmontools on my
Supermicro LSI 1068E controller with the target firmware for 2 years
now on CentOS 5. I have 3 RAID 1 arrays across 2 drives, a RAID 5
drive across 3 drives, and a RAID 0 across 2 drives.

I routinely will query smartctrl with something like

for i in a b c d e f; do smartctl -a /dev/sd$i | grep Reallocated; done

or

for i in a b c d e f; do smartctl -a /dev/sd$i | grep Temperature; done

Here are the system details

 cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [raid0]
md0 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[0]
      2032128 blocks [2/2] [UU]

md3 : active raid0 sdd1[1] sdc1[0]
      625137152 blocks 64k chunks

md4 : active raid5 sdg1[2] sdf1[1] sde1[0]
      1953519872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md1 : active raid1 sdb2[1] sda2[0]
      154151616 blocks [2/2] [UU]

lpsci
02:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
PCI-Express Fusion-MPT SAS (rev 08)

modprobe.conf
alias scsi_hostadapter mptbase
alias scsi_hostadapter1 mptsas

rpm -qa | grep smartmontools
smartmontools-5.38-2.el5

uname -r
2.6.18-128.4.1.el5

On Sun, Nov 8, 2009 at 5:59 PM, Richard Scobie <richard@sauce.co.nz> wr=
ote:
> Andrew Dunn wrote:
>>
>> I am not, but this is quite interesting. What versions are affected?=
 I
>> am in ubuntu 9.10.
>
> To my knowledge, there is no smartmontools version safe for use on th=
ese LSI
> based controllers.
>
> You may run smartctl commands a few times and get away with it, but
> eventually it will bite you.
>
> Losing 14 drives on a 16 drive array as a result, is no fun...
>
> Hopefully it will be fixed one day.
>
> Regards,
>
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
