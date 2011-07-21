From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Thu, 21 Jul 2011 17:06:41 +0200
Message-ID: <CACVpCE5mVBvqFBa7VNtGDiMKRn45Wh79gHqqnOu5vE6aeWEtgg@mail.gmail.com>
References: <201107181403.49563.raid1@fuckaround.org>
	<4E26CAA7.8030201@hardwarefreak.com>
	<c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org>
	<CAHX8RiR0MV1iL_OfrVAKGjr0gj7zxtuxFSzMijSgNfKcs0Zz0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHX8RiR0MV1iL_OfrVAKGjr0gj7zxtuxFSzMijSgNfKcs0Zz0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/7/21 Erwan Leroux <erwan.lerou@gmail.com>:
> following is how i configured advanced format drives for raid 5
> i created one partition on each disk
>
> fdisk -u /dev/sdX
> # -u change the unit displayed by fdisk to sector instead of
> cylinders, this way it's easier to configure
>
> # the table partition isn't really modifier until you send the w
> command, so if you messed up use the q to quit and restart
>
> #delete first partition of the disk, repeat until you had cleared the=
 disk
> d
>
> # create a new partition
> n
>
> # select primary parition
> p
>
> #select number one (don't know if number is important, i guess it's
> means /dev/sdX1)
> 1
>
> #select first sector, here is the catch, to properly align the disk, =
select 64
> 64
>
Why do you choose 64? One physical sector (4KiB) is 8 logical sectors
(512 B). Would any number greater or equal to 8 and evenly divisible
by 8 work as well? Are you aiming to align partition start with RAID
chunk boundaries?

Just curious.

Pawe=C5=82
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
