From: David Brown <david.brown@hesbynett.no>
Subject: Re: Removing physical disk from RAID & LVM
Date: Tue, 15 May 2012 10:58:01 +0200
Message-ID: <4FB21A99.1050405@hesbynett.no>
References: <4FB1E89F.5080407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB1E89F.5080407@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Tero_M=E4ntyvaara?= <termant@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/05/2012 07:24, Tero M=E4ntyvaara wrote:
> Hi,
>
> I have filesystem build up with 5 x 320 GB disks with identical
> partitions. Disks have 2 partitions and the first one is dedicated fo=
r
> RAID-1 (/dev/md0) and second one is dedicated for RAID-5 (/dev/md1). =
The
> disk /dev/md0 is mounted as /boot and the /dev/md1 is prepared for LV=
M.
> PE size is 32 MiB and there is 38035 PEs.
>
> I am going to remove one 320 GB disk and have already reduced the siz=
es
> of existing LV:s. 1) What is the sufficient free PE number before I c=
an
> imagine shrinking of RAID-5 device? 2) How should I procede after hav=
ing
> enough free PE:s?
>

Are you removing the disk permanently, or do you plan to replace it?


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
