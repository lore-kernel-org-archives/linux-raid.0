From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 2 Aug 2012 14:25:20 -0300
Message-ID: <CABYL=TpRAAWbfF_a_Wa=-aq5FbS9HLAAP7c+y2hUtwp=dWd=LA@mail.gmail.com>
References: <50191ADE.10809@fastmail.fm>
	<5019D052.4000409@hardwarefreak.com>
	<20120802091917.32fb0ca5@natsu>
	<501A316C.3020305@hardwarefreak.com>
	<20120802140634.6f729d07@natsu>
	<1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com>
	<CABYL=TpDU0YD4orJqyZzeYPtUJ+vBEeM=CWhFxa4GWGj8SjGMQ@mail.gmail.com>
	<501AB553.2030003@aeoncomputing.com>
	<20120802231923.45b6f1fc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120802231923.45b6f1fc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Jeff Johnson <jeff.johnson@aeoncomputing.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

btrfs and jfs have silent data corruption protection, but it could be
nice to have this at block layer, since some databases (innodb at
mysql) can use block device to allocate information (as a performace
boost), and since i know, it don=B4t have silent data corruption
protection...
a solution at block device is better than filesystem? yes and no, but
at block device we can use with any filesystem, even with fat16 or
other old filesystem
we could add more features in future (like jornaling) but i think just
data integrity layer is nice... there=B4s others features like
reallocation (when write to a silent write detected block, realloc it
to another block like good SSD do)



2012/8/2 Roman Mamedov <rm@romanrm.ru>:
> On Thu, 02 Aug 2012 10:13:55 -0700
> Jeff Johnson <jeff.johnson@aeoncomputing.com> wrote:
>
>> The only ways I know of to currently detect/repair silent data
>> corruption are via the use of T10-DIF on SAS drives with 520-byte
>> sectors and embedded per block CRCs (bytes 513-520) or via a patente=
d
>> algorithm used in a commercial Linux software RAID product
>> (www.streamscale.com).
>
> Well, you can simply use BTRFS RAID1/RAID10 (RAID5/6 to come some tim=
e soon).
> It has per block checksums and auto-healing from other drive(s) if da=
ta on
> some drive turns out not to match the checksums anymore.
>
> --
> With respect,
> Roman
>
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> "Stallman had a printer,
> with code he could not see.
> So he began to tinker,
> and set the software free."



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
