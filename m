From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Mon, 05 Mar 2012 09:38:34 +0000
Message-ID: <4F54899A.4040301@anonymous.org.uk>
References: <4F4C9A11.9060302@profihost.ag>	<4F4F4B1D.4050000@redhat.com>	<4F4F4EB3.6030909@profihost.ag>	<4F4F519E.7040206@redhat.com>	<4F508864.4050600@profihost.ag>	<20120302100648.fe4e725f2e98880c839357b0@bbaw.de>	<4F508EB6.2030101@profihost.ag>	<4F5091BF.1000102@anonymous.org.uk>	<4F509402.8070503@profihost.ag>	<4F50ABA3.1070603@anonymous.org.uk>	<4F50C7DC.3000700@profihost.ag> <20120302163236.3555fec1296cbe30d8d37972@bbaw.de> <4F547038.7060009@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F547038.7060009@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/03/2012 07:50, Stefan Priebe - Profihost AG wrote:
> Am 02.03.2012 16:32, schrieb Lars T=E4uber:
>> Hi Stefan,
>>
>> the metadata versions 1.0 and 1.1 and 1.2 are the same but for the p=
osition of
>> the metadata on disk. Simply use metadata version 1.0 and everything=
 works as
>> with 0.9.
>>
>> Grub does to read partition tables inside raid devices.

Sure it does, but that's not the point.

>> Because a raid1 with metadata 1.0 or 0.9 looks like a plain disk to =
grub it
>> can read a partition table like there was no raid array.

=46or the fourth time, no.

Because a RAID1 with metadata 0.9 or 1.0 looks like a plain disc to the=
=20
BIOS, it can read a partition table like there was no RAID array, and=20
therefore the BIOS can load GRUB.

> Ah OK thanks. using Metadata 1.0 works fine.

It will work OK, but just be very, very careful never to run a GPT=20
partition tool directly on /dev/sda or /dev/sdb, because it will write=20
the backup of the GPT partition table at the end of the disc,=20
potentially destroying the metadata for the array.

You would still be safer having partition tables on the drives, and=20
building your array(s) from those partition(s), the opposite way round=20
from how you are doing it just now.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
