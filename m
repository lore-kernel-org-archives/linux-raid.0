From: CoolCold <coolthecold@gmail.com>
Subject: Re: RAID halting
Date: Sat, 25 Apr 2009 00:28:37 +0400
Message-ID: <f19d625d0904241328k3724b9e2i8ef0e410c0d934f@mail.gmail.com>
References: <20090424045222253.GZTS2063@cdptpa-omta04.mail.rr.com>
	 <CBD259F5-4214-4C0C-A1D7-16ABC0A2BA89@redhat.com>
	 <49F22035.3020507@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F22035.3020507@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Doug Ledford <dledford@redhat.com>, lrhorer@satx.rr.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Apr 25, 2009 at 12:25 AM, Richard Scobie <richard@sauce.co.nz> =
wrote:
> Doug Ledford wrote:
>
>>> Also, in my reading it was suggested by several researchers the bes=
t
>>> performance of an XFS file system is achieved if the stripe width o=
f the
>>> FS
>>> is set to be the same as the RAID array using the su and sw switche=
s in
>>> mkfs.xfs.
>>
>> This is true of any raid aware file system. =A0I know how to do this=
 for
>> ext3, but not for xfs, so I won't comment further on that. =A0Howeve=
r, the
>> stripe size is always chunk size * number of non-parity drives on a =
parity
>> based array.
>
> mkfs.xfs will will query the md device for no. of devices and stripe =
size
> and automatically set this optimally (su and sw).

It will, but need dmsetup installed.

>
> If an array is later grown, these two values will need to be manually
> calculated and then be applied as mount options.
>
> Regards,
>
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
