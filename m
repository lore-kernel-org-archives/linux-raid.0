From: CoolCold <coolthecold@gmail.com>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 13:55:53 +0400
Message-ID: <f19d625d0904100255j1ee672b8ped4b6b517a7f9dc5@mail.gmail.com>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DF0D06.8030705@musmo.com>
Sender: linux-raid-owner@vger.kernel.org
To: admin@musmo.com
Cc: "Timothy D. Lenz" <tlenz@vorgon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, he should provide correct /etc/mdadm/mdadm.conf and
update-initramfs -u on md boot, smth like
chroot /mnt/md0
update-initramfs -u

On Fri, Apr 10, 2009 at 1:10 PM, KwangErn Liew <admin@musmo.com> wrote:
>
> Timothy D. Lenz wrote:
>>
>> Ended with warning: unable to open an initial console. I was able to
>> scroll back and didn't really see any errors. Don't know if I
>> missed a change to some config file or something else that should be=
 built
>> into the kernel. I have gone over a lot of "guides" and
>> don't see what is missing.
>
> FYI, I've never been successful in booting RAID without initrd even t=
hough
> all necessary modules are built-in. I guess mdadm.conf requires initr=
d to
> kick start?
>
>
> KwangErn
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
