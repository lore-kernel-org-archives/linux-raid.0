From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: sync_action repair not reading all sectors?
Date: Tue, 17 Mar 2009 14:46:29 -0700
Message-ID: <e9c3a7c20903171446w122ef4f5ibb127b9cbec3c636@mail.gmail.com>
References: <49BE3786.50809@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49BE3786.50809@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 16, 2009 at 4:27 AM, David Greaves <david@dgreaves.com> wro=
te:
> I have a drive that has bad sectors. Lots of them.
>
> smartctl shows
> # 1 =A0Short offline =A0 =A0 =A0 Completed: read failure =A0 =A0 =A0 =
20% =A0 =A0 =A0 530
> 1953520877
>
> A simple ddrescue to this part of the disk gets this:
>
> Mar 16 10:41:28 elm kernel: [ 8643.123397] sd 3:0:0:0: [sdd] 19535251=
68 512-byte
> hardware sectors (1000205 MB)
> <snip<>51/40:00:f0:5c:70/00:00:74:00:00/e0 Emask 0x9 (media error)
> Mar 16 10:41:29 elm kernel: [ 8644.190060] ata4.00: status: { DRDY ER=
R }
> Mar 16 10:41:29 elm kernel: [ 8644.190099] ata4.00: error: { UNC }
>
> and reports 30 or so errors.
>
>
> mdstat tells me:
> md0 : active raid5 sdd1[0] sdb1[2] sda1[1]
> =A0 =A0 =A01953519872 blocks level 5, 64k chunk, algorithm 2 [3/3] [U=
UU]
>
> So sdd1 is in there.
>
> /dev/sdd1 is the full disk
>

Are you sure?  Maybe I did the following math wrong, but it seems
there is a chance this bad region is outside the raid array.
/proc/mdstat says the array is 1953519872 blocks large which is
3907039744 sectors.  For a three disk raid5 that means we are using
1953519872 sectors per disk.  The failing sector of 1953520877 is 1005
sectors outside the array, probably 942 assuming partition 1 starts at
sector 63??

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
