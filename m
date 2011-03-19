From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: MD without LVM : should I reinstall ?
Date: Sat, 19 Mar 2011 16:45:47 +0000
Message-ID: <4D84DDBB.5000708@anonymous.org.uk>
References: <201103172232.28515.thocar@thocar.org>	<AANLkTinG1RSiXZZdN+Fc__AJ14hAAua8gxySbbM_C3gZ@mail.gmail.com>	<201103182159.40249.thocar@thocar.org> <AANLkTinxz=CJ6VReNfSdQ=QXT8+VBEwCK6OriOB34ah=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinxz=CJ6VReNfSdQ=QXT8+VBEwCK6OriOB34ah=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: thocar@thocar.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/03/2011 21:12, Mathias Bur=C3=A9n wrote:
> On 18 March 2011 20:59, Thomas Carri=C3=A9<thocar@thocar.org>  wrote:
[...]
>> Have a look at the command output : "Disk /dev/md0 doesn't contain a=
 valid
>> partition table"
>>
>> Is it safe to ignore this warning ?
[...]
>
> AFAIK you'll see that "warning" if you use LVM (I see it in my setup)=
,
> as LVM isn't a file system per se.

I've a feeling that message appears with any kernel that supports=20
general partitionable devices if the device isn't partitioned, e.g. you=
=20
put a filesystem on your md device. If /dev/md0 isn't meant to be=20
partitioned, it's harmless.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
