From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Wed, 19 Oct 2011 14:01:16 +0200
Message-ID: <CAGRgLy5rkhfqnYHTt89f8QkigYPHDFdcciP2ZQp1tkcYq2wqNg@mail.gmail.com>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
	<CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
	<20110921150323.0ef402c9@notabene.brown>
	<CAGRgLy7fKegKw6j-36o0uchTF35F4hT8NvujW4ghb5av-onCGQ@mail.gmail.com>
	<20110925201510.24e0f468@notabene.brown>
	<CAGRgLy6Ew-mDK-u+Gz9Ae8gKzjC+qJBxM_=Xm6x=VBJBPeOaeg@mail.gmail.com>
	<20111012144531.7479596a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111012144531.7479596a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, Neil.
I experimented with --force switch, and I saw that when using this
switch it is possible to start the array, even though I am sure that
the data will be corrupted. Such as selecting stale drives (which have
been replaced previously etc.)
Can I have some indication that it is "relatively safe" to start the
array with --force?
=46or example, in the case of "dirty degraded", perhaps it might be
relatively safe.

What should I look at? The output of --examine? Or something else?

Thanks,
  Alex.


On Wed, Oct 12, 2011 at 5:45 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 11 Oct 2011 15:11:47 +0200 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Hello Neil,
>> can you please confirm for me something?
>> In case the array is FAILED (when your enough() function returns 0) =
-
>> for example, after simultaneous failure of all drives - then the onl=
y
>> option to try to recover such array is to do:
>> mdadm --stop
>> and then attempt
>> mdadm --assemble
>>
>> correct?
>
> Yes, though you will probably want a --force as well.
>
>>
>> I did not see any other option to recover such array Incremental
>> assemble doesn't work in that case, it simply adds back the drives a=
s
>> spares.
>
> In recent version of mdadm it shouldn't add them as spare. =A0It shou=
ld say
> that it cannot add it and give up.
>
> NeilBrown
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
