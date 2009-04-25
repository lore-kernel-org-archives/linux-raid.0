From: =?ISO-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>
Subject: Re: RAID halting
Date: Sat, 25 Apr 2009 10:53:25 +0200
Message-ID: <6c4602af0904250153i4dd01201j85b54aef24445a0c@mail.gmail.com>
References: <CBD259F5-4214-4C0C-A1D7-16ABC0A2BA89@redhat.com>
	 <20090425074027510.YPAD9976@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090425074027510.YPAD9976@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Doug Ledford <dledford@redhat.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/4/25 Leslie Rhorer <lrhorer@satx.rr.com>:
> I went ahead and selected 256K.  There's something a little odd, though.
> mdadm is reporting a device size of 2T.  These are 1T drives.  The overall
> array size is correct but the device size is goofy.  I hope this doesn't
> cause any problems.  As I believe I mentioned before (or maybe it was on
> another list), I once had problems with ext3 trying to read beyond the
> physical end of the array.
>
> RAID-Server:/Backup/Personal_Folders# mdadm -Dt /dev/md0
> /dev/md0:
>        Version : 01.02
>  Creation Time : Sat Apr 25 01:17:12 2009
>     Raid Level : raid6
>     Array Size : 7814098944 (7452.11 GiB 8001.64 GB)
>  Used Dev Size : 1953524736 (1863.03 GiB 2000.41 GB)

It's a bug in mdadm, probably leftover from blocks/sectors migration,
I believe it was fixed in 2.6.9. The reality is looking okay, array is
safe, it's just mdadm miscalculating on the very last stage of output.

Greets,
Mike
