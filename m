From: CoolCold <coolthecold@gmail.com>
Subject: Re: MD does not wait for drives on start-up with kernels 3.8+
Date: Sun, 31 Mar 2013 09:36:30 +0400
Message-ID: <CAGqmV7qmPHYpm1rinfsh5W-mgqo+Va2RvQtZoy-5AazYFAHYdg@mail.gmail.com>
References: <20130330190538.4e3c1771@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130330190538.4e3c1771@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In similar situation (but on 2.6.2x kernels i AFAIR, with scsi drives)
I've used rootdelay param -
http://lists.debian.org/debian-user/2012/01/msg00748.html to make md
assembly succeed. Hope this will help you too.

P.S. to Neil B.
Just wondering why md prints something like "md: md0 stopped" - why it
is stopped without being started, this confuses me all the time? Is
this message just to indicate that array isn't assembled, not started?
If so, I'd suggest to change it to something like:
"md: md0 is in stopped state"

On Sat, Mar 30, 2013 at 5:05 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> Hello,
>
> I got a bizzare problem after trying to upgrade from 3.7.10 (which works fine)
> to 3.8.3 or 3.9-rc3 (fail in the same way):
>
> It looks like on the newer kernels MD does not wait for all drives to finish
> registering before trying to bring up the arrays. As a result, on newer
> kernels my arrays always come up with only 5 out of 7 members active.
>
> dmesg 3.7.10:  http://romanrm.ru/dl/mdadm/dmesg37.txt
> dmesg 3.9-rc3: http://romanrm.ru/dl/mdadm/dmesg39.txt
>
> As you can see on 3.7.10 drives continue to go online until about 3.89sec
> (Hitachi) and 4.26sec (card reader, unrelated), and only THEN, at 5.15sec the
> md0 starts; it has all drives and everything is good.
>
> On 3.9-rc3 (and 3.8.3), md0 tries to become active VERY EARLY at 2.64sec of
> boot-up!!! Of course missing drives which appear later, and of those, members
> of it should have been two Hitachi drives coming up at 3.33sec and 3.87sec.
> So it starts degraded with 5 of 7 devices only.
>
> What's up with this? I understand this might be not an md problem but an
> udev(?) one; but how do I go about solving this?
>
> --
> With respect,
> Roman
>
> (resending this message since the previous one with largish attachments
> didn't seem to make it to the list; also used a different dmesg for 3.7)



-- 
Best regards,
[COOLCOLD-RIPN]
