From: Dylan Distasio <interzone@gmail.com>
Subject: Re: Question on md126 / md127 issues
Date: Sat, 28 May 2011 18:15:54 -0400
Message-ID: <BANLkTimirBv2O_s91wKjf56OAt4m-iTnWg@mail.gmail.com>
References: <BANLkTinePbV0qfs5XXy9cZQ2a7bQfO=FVQ@mail.gmail.com> <20110528073602.128cebc0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110528073602.128cebc0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, Neil.

I think running mkinitrd was probably the only thing required for a
fix after reading your response.  I had an older array on the same box
that was completely removed, but maybe something was leftover in
initrd.

My detailed understanding of the initrd process is fairly limited.  I
didn't realize there was a separate mdadm.conf that was used when
booting that is separate from the one in /etc.


> Running mkinitrd when you have boot problems is always a good idea. =A0=
Maybe
> that was all it took to fix your problem ??
>
>
>>
>> I had to run the above commands, and then make sure I ran
>> update-initramfs -v -u for it to stick after reboot.
>>
>> My issue is solved, but I would like to understand what the root cau=
se
>> is, and why the above solution worked. =A0Can someone elaborate on w=
hat
>> super-minor is? =A0This is a home system and I had backups so I was
>> comfortable trying the above, but I don't typically like running
>> commands on faith I don't understand fully, especially in Linux.
>>
>> Can anyone shed some light on this? =A0I can provide further OS and
>> array details if necessary, but it sounds like this issue has occurr=
ed
>> for others in the past.
>
> Now that the problem is fixed it is very hard to figure out what was =
happening
> before. =A0My best guess is that someone was wrong with mdadm.conf in=
 the
> initrd, but I don't know what.
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
