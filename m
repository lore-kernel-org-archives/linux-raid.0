From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID1 content under Windows OS
Date: Tue, 21 Feb 2012 22:20:09 +0100
Message-ID: <4F440A89.6000606@hesbynett.no>
References: <FCC44AC27019AF49B444F7E7F684FABD01DE8B605CA4@GMVMAIL4.gmv.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FCC44AC27019AF49B444F7E7F684FABD01DE8B605CA4@GMVMAIL4.gmv.es>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?=C1lvaro_L=F3pez_L=F3pez?= <allopez@gmv.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/02/12 19:50, =C1lvaro L=F3pez L=F3pez wrote:
> I have been able to create a RAID 1 device in a Linux 2.6.36 system
> using mdadm command.
>
> Both disks had been formatted using mkdosfs in order to be mounted
> with type vfat. I also changed its label using cfdisk from "Linux" to
> the "W95 FAT32".
>
> After mounting the RAID1 device MD0 in the filesystem, I copy some
> files inside the folder associated to the RAID1. I can see the
> contents when MD0 is mounted inside Linux, not if disks are mounted
> separately.
>
> Then, when I connect both disks to a Windows XP or 7 OS I cannot see
> any content inside them.
>
> Is it possible to see the content? What can I do?
>
> Thanks in advance,
>
> Alvaro
>

I think it will be the metadata format that is the problem - by default=
,=20
mdadm creates arrays with format 1.2 that is 4K from the start of the=20
partition.  But this will confuse windows (or anything else that tries=20
to read the partition directly).  If you create the array with format=20
1.0, the metadata is placed at the end of the partition and windows wil=
l=20
not notice it, and will therefore it will be able to see the filesystem=
=20
properly.

Of course, if you /change/ anything on the filesystem from within=20
windows, you will completely screw the array.

mvh.,

David
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
