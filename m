From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Tue, 13 Sep 2011 11:49:12 +0300
Message-ID: <CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110830072557.428fab35@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,
I am sorry for opening this again, but I am convinced now that I don't
understand what's going on:)

Basically, I see that GET_ARRAY_INFO can also return ENODEV in case
the device in the kernel exists, but "we are not initialized yet":
/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
if ((!mddev->raid_disks && !mddev->external)
    && cmd !=3D ADD_NEW_DISK && cmd !=3D STOP_ARRAY
    && cmd !=3D RUN_ARRAY && cmd !=3D SET_BITMAP_FILE
    && cmd !=3D GET_BITMAP_FILE) {
	err =3D -ENODEV;
	goto abort_unlock;

I thought that ENODEV means that the device in the kernel does not
exist, although I am not this familiar with the kernel sources (yet)
to verify that.

Basically, I just wanted to know whether there is a reliable way to
determine whether the kernel MD device exists or no. (Obviously,
success to open a devnode from user space is not enough).

Thanks,
  Alex.







On Tue, Aug 30, 2011 at 12:25 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 29 Aug 2011 20:17:34 +0300 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Greetings everybody,
>>
>> I issue
>> mdadm --stop /dev/md0
>> and I want to reliably determine that the MD devnode (/dev/md0) is g=
one.
>> So I look for the udev 'remove' event for that devnode.
>> However, in some cases even after I see the udev event, I issue
>> mdadm --detail /dev/md0
>> and I get:
>> mdadm: md device /dev/md0 does not appear to be active
>>
>> According to Detail.c, this means that mdadm can successfully do
>> open("/dev/md0") and receive a valid fd.
>> But later, when issuing ioctl(fd, GET_ARRAY_INFO) it receives ENODEV
>> from the kernel.
>>
>> Can somebody suggest an explanation for this behavior? Is there a
>> reliable way to know when a MD devnode is gone?
>
> run "udevadm settle" after stopping /dev/md0 =A0is most likely to wor=
k.
>
> I suspect that udev removes the node *after* you see the 'remove' eve=
nt.
> Sometimes so soon after that you don't see the lag - sometimes a bit =
later.
>
> NeilBrown
>
>>
>> Thanks,
>> =A0 Alex.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
