From: "Majed B." <majedb@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 02:39:12 +0300
Message-ID: <70ed7c3e0910231639r974424cv750c638356fbfc82@mail.gmail.com>
References: <4b85f6ec7a52d1a124696941b382c2b0.squirrel@neil.brown.name>
	<885316.78847.qm@web38805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <885316.78847.qm@web38805.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Perhaps the program utils for ext2 were uninstalled as well just like
what happened to the JFS ones?

Double check. Also, paste the errors in Google and look for similar inc=
idents.

On Sat, Oct 24, 2009 at 2:25 AM, adfas asd <chimera_god@yahoo.com> wrot=
e:
> --- On Fri, 10/23/09, NeilBrown <neilb@suse.de> wrote:
>> Clearly md0 is degraded - one device is missing.
>> You need to find out why. =C2=A0Then if you trust the
>> missing device to
>> keep working, add it back in (mdadm --add ...)
>>
>> dmesg or /var/log/something might have hints as to what the
>> error
>> was that caused md to reject the device.
>
> Thanks Neil, this is the first constructive advice all day.
>
> Klipper isn't working for some reason, so I can't post the exact erro=
r, but dmesg and /var/log/messages say md0 has an unknown partition tab=
le (this time for ext2), just like with the prior problem on md2 (with =
jfs).
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
