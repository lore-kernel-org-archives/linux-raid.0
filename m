From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Raid 5 to 6 grow stalled
Date: Sun, 10 Apr 2011 16:09:39 +0100
Message-ID: <BANLkTik9hdemypqwF_-3sCmz4o78vTrOFA@mail.gmail.com>
References: <1302366232.12096.1439264077@webmail.messagingengine.com>
	<20110410073039.2d9683ac@notabene.brown>
	<1302447763.8724.1439486933@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1302447763.8724.1439486933@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Siefker <hatta00@fastmail.fm>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10 April 2011 16:02, Edward Siefker <hatta00@fastmail.fm> wrote:
>
>>
>> Doesn't look good..
>> What version of mdadm? =C2=A0What kernel?
>>
>> NeilBrown
>>
>
>
>
> root@iblis:~# mdadm --version
> mdadm - v3.1.4 - 31st August 2010
> root@iblis:~# uname -a
> Linux iblis 2.6.38-2-amd64 #1 SMP Tue Mar 29 16:45:36 UTC 2011 x86_64
> GNU/Linux
>
> Did you see the other post I made? =C2=A0The array still
> reports as clean, but I haven't tried to mount it yet.
> This array started out as a RAID1, which I changed to
> RAID5, added a disk, reshaped, and added a spare to.
> This worked great and I used it for a couple weeks
> before deciding to go to RAID6.
>
>
> Looking at the output of 'mdadm -E' and 'mdadm -D'
> (again in the other post), it looks like there's
> some inconsistency in the raid device for /dev/sde1.
> -E reports it as number 4 and raid device 4. But,
> -D says /dev/sde1 is number 4 and raid device 3.
> Don't know if that means anything, but it's the
> only thing I see that looks unusual.
>
> Since the array is clean, is it safe to mount it?
> It's actually a luks volume, fwiw. =C2=A0Thanks
> --
>
> =C2=A0hatta00@fastmail.fm
>
> --
> http://www.fastmail.fm - mmm... Fastmail...
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Just try a fsck -n ?

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
