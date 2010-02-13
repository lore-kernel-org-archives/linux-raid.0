From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 01:26:27 -0800
Message-ID: <4877c76c1002130126m7ff93c33m5159eb4e554d22b4@mail.gmail.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
	 <4B7664AC.4080504@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B7664AC.4080504@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 13, 2010 at 12:37 AM, Giovanni Tessore <giotex@texsoft.it> =
wrote:
>
>> I may be converting a host to ext4 and was curious, is 0.90 still th=
e only
>> superblock version for mdadm/raid-1 that you can boot from without h=
aving to
>> create an initrd/etc?
>>
>> Are there any benefits to using a superblock > 0.90 for a raid-1 boo=
t
>> volume < 2TB?
>
> I recently reinstalled my systems, and I had to use superblock 0.9 to=
 be
> able to boot ext4 from raid-1 (kernel 2.6.31 - grub2 1.97-beta4).
> I didn't go deep with it as I was quite in hurry, so I'm not sure if =
it
> depends by grub2 or by kernel's md autodetection at boot.
> I used superblock 1.1 for the others md devices.
>
> The advantage of superblocks >=3D 1.0 that I prefere is that they per=
sist the
> number of recovered read errors; this allow to monitor (at the moment
> manually via /sys/block/mdXX/devYY/errors) across system restarts the=
 health
> of devices into the array, useful for raid-5 and 2-disks raid-1.
>
> Regards
>
> --
> Cordiali saluti.
> Yours faithfully.
>
> Giovanni Tessore
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

mdadm 1.0 block devices, since stored at the end, can still be used
/read only/ the same way that 0.90 devices were used before grub knew
how to talk to them.  By looking at the underlying block devices and
ignoring their tails.  This does however only hold for raid-1 layouts
with the 1.0 or 0.90 format labels.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
