From: Mirko Benz <mirko.benz@web.de>
Subject: Re: parity check for read?
Date: Wed, 04 Apr 2007 13:29:10 +0200
Message-ID: <46138C06.5020903@web.de>
References: <461254DF.3050503@web.de> <17938.49705.840745.66635@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17938.49705.840745.66635@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

Exactly what I had in mind.

Some vendors claim they do parity checking for reads. Technically it=20
should be possible for Linux RAID as well but is not implemented =96 co=
rrect?

Reliability data for unrecoverable read errors:
- enterprise SAS drive (ST3300655SS): 1 in 10^16 bits transfered, ~ 1=20
error in 1,1 PB
- enterprise SATA drive (ST3500630NS): 1 in 10^14 bits transfered, ~ 1=20
error in 11 TB

=46or a single SATA drive @ 50 MB/s it take on average 2,7 days to=20
encounter an error.
=46or a large RAID with several drives this becomes much lower or am I=20
viewing this wrong?

Regards,
Mirko

Neil Brown schrieb:
> On Tuesday April 3, mirko.benz@web.de wrote:
>  =20
>> Hi,
>>
>> Is parity calculation and validation for read operations supported?
>>    =20
>
> I guess what you are asking is:
>
>    With raid5, I would like the drive to handle a read request by
>    reading all the blocks in the stripe and checking the parity.  If
>    the parity is correct, return the data blocks.  If it is not, then
>    fail the read request.  Is that possible?
>
> No, it is not.
>
> If you are really asking something else, please be more specific.
>
> NeilBrown
>
>  =20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
