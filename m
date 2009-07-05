From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: mdadm --wait doesn't
Date: Sun, 5 Jul 2009 16:37:15 -0500
Message-ID: <cccedfc60907051437l3309ace5mee09baba2bc51a49@mail.gmail.com>
References: <cccedfc60907051035o1753ea61r7098c2ea2c8ded9@mail.gmail.com>
	<4A5112F3.8080504@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A5112F3.8080504@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jul 5, 2009 at 3:54 PM, John
Robinson<john.robinson@anonymous.org.uk> wrote:
> On 05/07/2009 18:35, Jon Nelson wrote:
>>
>> I was trying to use mdadm --wait a bit ago to wait for a recovery
>> operation, but mdadm --wait didn't actually wait.
>>
>> Here is md12 after adding /dev/sdf1 back to it.
>>
>> md12 : active raid1 sdf1[3] nbd0[2](W)(F) sde[0]
>> =A0 =A0 =A072612988 blocks super 1.1 [3/1] [U__]
>> =A0 =A0 =A0[>....................] =A0recovery =3D =A03.0% (2195456/=
72612988)
>> finish=3D51.4min speed=3D22805K/sec
>> =A0 =A0 =A0bitmap: 139/139 pages [556KB], 256KB chunk
>>
>> However, mdadm /dev/md12 --wait (and --wait-clean) did not wait for
>> the recovery to be complete.
>>
>> turnip:~ # mdadm /dev/md12 --wait
>> turnip:~ # echo $?
>> 0
>> turnip:~ # mdadm --version
>> mdadm - v3.0 - 2nd June 2009
>>
>> I would --fail and --remove /dev/sdf1 and try again (with --add), an=
d
>> I did this several times, and I could not get it to wait until the
>> recovery was complete.
>>
>> Am I doing something wrong? Did I mis-read the documentation?
>
> Did you try `mdadm --wait /dev/md12`? For me that returns 1 on a full=
y-up
> array (where there's nothing to wait for) while `mdadm /dev/md12 --wa=
it`
> returns 0, so they're obviously handled differently. I don't really f=
eel
> like degrading an array to test further, I'll leave it to you :-)

OK, that's weird. mdadm /dev/md12 --wait doesn't, while mdadm --wait
/dev/md12 does.
That doesn't seem right to me.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
