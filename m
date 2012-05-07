From: =?UTF-8?Q?Gar=C3=B0ar_Arnarsson?= <gardar@giraffi.net>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Mon, 7 May 2012 00:35:47 +0000
Message-ID: <CAH-e9vJuRCKmGn9vHgU32UggHH-GeKzfd1aFCRpA_7Acodg9ow@mail.gmail.com>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com>
 <CAH-e9vLiK6=HmDjM=Ub7p_Lxrp_L0x1bkAa2oP=ykajqvtkfDQ@mail.gmail.com>
 <20120506210028.6212b2f8@notabene.brown> <CAH-e9vJkrv2R-HTR7JfHwZK1sbYQ3fduGbtxEwtor4gtyd6PKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9vJkrv2R-HTR7JfHwZK1sbYQ3fduGbtxEwtor4gtyd6PKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That's an excellent idea, I was going to add another disk for extra
space right after migrating to raid6.

Just to be clear, I'll be running the normalize attribute just once to
straighten the array out right? Or will I have to do it for every
extra drive I add in the future?

And what are the N+1 you mention in --raid-devices=3DN+1

 Thanks.



2012/5/6 NeilBrown <neilb@suse.de>
>
> On Sun, 6 May 2012 10:17:52 +0000 Gar=C3=B0ar Arnarsson <gardar@giraf=
fi.net> wrote:
>
> > My raid5 array has gotten a bit big, it's containing total 10 drive=
s
> > right now (I started out with 3 drives). So I am going to convert i=
t
> > to raid6 before it gets any bigger.
> >
> > I am doing a test-run on a virtual machine with virtual drives to s=
ee
> > that everything works flawlessly.
> >
> > When I tried to convert the array to raid6 I got a error message ab=
out
> > a missing backup-file
> >
> > mdadm --grow /dev/md0 --raid-devices=3D5 --level=3D6
> >
> > mdadm level of /dev/md0 changed to raid6
> > mdadm: /dev/md0: Cannot grow - need backup-file
> > mdadm: aborting level change
> >
> > I added the backup file and was able to convert the array successfu=
lly
> > after that.
> >
> > My question is, how big is this backup file going to be? My real ra=
id
> > array consists of 2tb drives, will the backup file be as big as one
> > drive in the array, or will it just be few megabytes or gigabytes?
> > I'm asking because I'm wondering if I need to buy an extra hdd for =
the
> > backup file or if the backup file can just be on my OS hdd that has
> > around 100gb free.
>
> The backup file is a few megabytes. Around 16MB I think.
>
> However if you are likely to add another device in the not too distan=
t future
> you can save yourself a bit of time.
>
> If you
>
> =C2=A0mdadm --grow /dev/md0 --level=3D6 --layout=3Dpreserve
>
> It will just make the new few a 'Q-block' device, containing the extr=
a RAID6
> 'parity' block for each stripe. =C2=A0This doesn't require any reshap=
e or or any
> backup file and is a lot faster. =C2=A0All it requires is a normal re=
covery
> operation.
>
> Then when you later add another device you can
>
> =C2=A0mdadm --grow /dev/md0 --raid-devices=3DN+1 --layout=3Dnormalise
>
> This will convert from the Q-on-the-last-device layout to a more norm=
al
> rotated-P-and-Q layout at the same time as adding extra space.
>
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
