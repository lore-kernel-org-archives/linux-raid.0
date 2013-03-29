From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID-10 with mixed block size HDDs
Date: Fri, 29 Mar 2013 14:22:10 +0100
Message-ID: <51559582.7000406@hesbynett.no>
References: <1036112.4.1364562908784.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1036112.4.1364562908784.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/03/13 14:15, Roy Sigurd Karlsbakk wrote:
>>>> Hi all,
>>>>
>>>> I've a two disk RAID-10 (far 2, I guess).
>>>
>>> You can't grow a RAID-10=E2=80=A6
>>
>> I know, I've to replace a disk, non add.
>
> I just don't understand why anyone would create a two-drive RAID-10,
> losing the flexibility of a mirror, and gaining nothing (since it's
> only on two drives)
>

With "far" layout, linux RAID-10 on two harddisks will give you the=20
safety of RAID-1 mirroring with /faster/ than RAID-0 speeds on reads.=20
(Writes are often a little slower than standard RAID-1 due to more head=
=20
movement, but slow writes can be buffered, while fast reads mean a=20
faster machine.)

Yes, you lose a bit of flexibility, and it would be very nice if RAID-1=
0=20
could be re-shaped, grown, etc.  But for a desktop system in particular=
,=20
RAID-10,far2 is the best you can get for two disks.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
