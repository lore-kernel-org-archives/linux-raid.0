From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Tue, 30 Aug 2011 18:18:11 +0300
Message-ID: <CAGRgLy4PCVCDuxiwC1BSo7Hj=_RNVoKdRRB_+NgkPA8+FsOy0Q@mail.gmail.com>
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

Thanks, Neil.

Although according to udev documentation: "the udev events are sent
out after udev has finished its event processing, all rules have been
processed, and needed device nodes are created."

Also looking at udev-worker code of udevd, the
udev_monitor_send_device() call is done after all the rules have been
processed.

Nevertheless, I looked at udevadm_settle.c and did some equivalent of
that in my code, and it looks like the issue is resolved. Perhaps
there is something md-specific here?

Another thing, since you are reading this thread, I wanted to ask
whether you have any advice on the "RAID5: failing an active component
during spare rebuild - arrays hangs" thread I opened some time ago.
Since you were not answering, I assume there is nothing additional you
can advise about, correct? I apologize if this off-topic was
inappropriate.

Thanks for the help,
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
