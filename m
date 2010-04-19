From: CoolCold <coolthecold@gmail.com>
Subject: Re: RAID Class Drives`
Date: Tue, 20 Apr 2010 00:10:31 +0400
Message-ID: <o2vf19d625d1004191310r9d1e3337jd48d2376f2df3c15@mail.gmail.com>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>
	 <7db987b31003181243n159eb7e9re2b614295221eee@mail.gmail.com>
	 <y2if19d625d1004180511m5f4032cp99f866024f76d93a@mail.gmail.com>
	 <4BCB6484.7040500@stud.tu-ilmenau.de>
	 <h2rf19d625d1004190311qefcc12f3q599acd47d8732046@mail.gmail.com>
	 <4BCC7C27.1000606@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCC7C27.1000606@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 19, 2010 at 7:52 PM, Stefan /*St0fF*/ H=FCbner
<stefan.huebner@stud.tu-ilmenau.de> wrote:
> Hi again!
>
> Am 19.04.2010 12:11, schrieb CoolCold:
>> Stop-stop. It is clear that timeouting "read" request in short perio=
d
>> is good idea, but i wanna know about writes
>> Does write fail because controller returns smth like "media error" o=
r
>> md has internal operation timeouts?
>
> Afaik the kernel has internal timeouts, that make unresponsive disks
> drop out.
>
>> Even if drive doens't become irresponsible and returns "error on
>> write" it will be dropped anyway.
>
> I'm not sure, you might be right.
>>
>> So, SCT-ERC setting will prevent drive to be irresponsible for long
>> time which may be desirable in case of:
>> a) md doesn't have it's own timeouting mechanism and the whole md
>> device will be stucked
>> b) drive ( another partition ) is part of another array/lvm
>> pv/whatever and that device will be stucked too.
>>
>
> Nope. =A0In the ATA8-ACS it is noted about like that: if the erc time=
r is
> about to expire, it is the duty of the drive to reallocate the sector
> and save the data-to-write onto the spare sector.
>
> So actually, if a write error occurs the drive should never report it=
 as
> long as spare sectors are available. =A0That's because of ncq/tcq and=
 scsi
> taskfiles - which make it nearly impossible to find out which write
> command failed and reconstruct the data for a retry. =A0On the other =
hand:
> the drive should still know the data somehow ;)
>
> The same applies to non-enabled write-erc. =A0The drive only runs the
> whole error-correction before it reallocates the sector (I had this 1=
4
> times already (according to SMART) on my laptop - weird if it doesn't
> respond for 2min, but then all of a sudden everything's great again).
>
> All the best and I hope I could help at least a bit,
> Stefan
>

Thanks a lot!

After some additional googling, i've found similar dialogue on this
list - http://kerneltrap.org/mailarchive/linux-raid/2010/3/25/6883733
=2E It's contents and links cleared almost anything for me.

1) ERC ( TLER / CCTL ) is primary aimed on read requests.
2) Should help on writes because "if the erc timer is about to expire,
it is the duty of the drive to reallocate the sector and save the
data-to-write onto the spare sector"

Accoring to this statements, if md kicked out drive with ERC enabled,
drive is almost dead. Is it true in practice?;)

--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
