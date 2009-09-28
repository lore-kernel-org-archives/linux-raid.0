From: "Majed B." <majedb@gmail.com>
Subject: Re: mdadm 3.0.2 won't read mdadm.conf file
Date: Mon, 28 Sep 2009 19:32:12 +0300
Message-ID: <70ed7c3e0909280932h326730c4u2606044bbc6bce06@mail.gmail.com>
References: <1e36c70e0909280013o616d74draf419a548183cc7f@mail.gmail.com>
	<73e903670909280218t44e1ddb0u8117ea4611643883@mail.gmail.com>
	<1e36c70e0909280536s513fa655n9533efe220dceddf@mail.gmail.com>
	<73e903670909280553t3de93c68t5673ba234ac72bef@mail.gmail.com>
	<1e36c70e0909280652j42ee420mabaa4141363a976a@mail.gmail.com>
	<73e903670909280704r1189e86aoc08cbc260e6d8ab8@mail.gmail.com>
	<1e36c70e0909280714r2d81238dq198699a863be359e@mail.gmail.com>
	<1e36c70e0909280748m160c190an453de1a773a96c48@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1e36c70e0909280748m160c190an453de1a773a96c48@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aggelos Kyritsis <filodoksos@gmail.com>
Cc: linux-raid@vger.kernel.org, =?UTF-8?Q?Kristleifur_Da=C3=B0ason?= <kristleifur@gmail.com>
List-Id: linux-raid.ids

Did you update initramfs after installing mdadm 3.0.2?

On Mon, Sep 28, 2009 at 5:48 PM, Aggelos Kyritsis <filodoksos@gmail.com=
> wrote:
> Well, I tried a simple and dirty solution (aren't they the best?) and=
 it worked:
>
> On a fresh install of Ubuntu (I 'm a bit format-happy) I installed
> mdadm version 2.6.7 (or something) from the repositories:
> ------------
>
> sudo apt-get install mdadm
>
> sudo mdadm -A --scan
>
> sudo su
>
> mdadm --detail --scan >> /etc/mdadm/mdadm.conf
>
> gedit /etc/mdadm/mdadm.conf (made some corrections there, corrected
> metadata 00.90 to 0.90)
>
> mkdir /home/cthulhu/raid
>
> chown -R cthulhu:cthulhu /home/cthulhu/raid
>
> echo "/dev/md0 /home/cthulhu/raid auto defaults 0 3" >> /etc/fstab
>
> gedit /etc/fstab (to make sure it was correctly added)
>
> -----------
>
> Then I compiled version 3.0.2, reboot, and now the system correctly
> mounts the array on startup. Checked mdadm --version and it is indeed
> 3.0.2, 25 September 2009
>
> I 'm really curious, though, why the plain vanilla 3.0.2 installation
> wouldn't work for me.
>
>
> On Mon, Sep 28, 2009 at 5:14 PM, Aggelos Kyritsis <filodoksos@gmail.c=
om> wrote:
>> Even if they are compiler flags, they are referring to the exact sam=
e
>> file (mdadm.conf) that my mdadm 3.0.2 completely ignores. It might b=
e
>> a complete coincidence, but it does look suspicious, doesn't it?
>>
>> I resend the attachment for the list to see
>>
>> On Mon, Sep 28, 2009 at 5:04 PM, Kristleifur Da=C3=B0ason
>> <kristleifur@gmail.com> wrote:
>>> Hi,
>>>
>>> it looks like we have actually started talking off-list :) (I think=
 so at
>>> least ...)
>>>
>>> Btw, Those "-Werror" things are compiler flags (it means "warn on e=
rror") --
>>> you're getting neither errors nor warnings there -- compilation is =
going
>>> fine
>>>
>>> You'd better take this back to the list, there's probably smarter p=
eople
>>> than me there ... and maybe also try the Ubuntu forums
>>>
>>> -- Kristleifur
>>>
>>> On Mon, Sep 28, 2009 at 1:52 PM, Aggelos Kyritsis <filodoksos@gmail=
=2Ecom>
>>> wrote:
>>>>
>>>> I think I found the cause of the whole situation.
>>>>
>>>> During the compilation of mdadm 3.0.2 several error messages appea=
r
>>>> considering the mdadm.conf file.
>>>>
>>>> I attach a file with the compiler's output. I have a feeling that =
if
>>>> we can pinpoint the cause of those errors, the problem will be sol=
ved.
>>>>
>>>> Maybe my system is missing some compilation libraries? I have alre=
ady
>>>> installed the build-essential and gcc packages.
>>>>
>>>>
>>>>
>>>> On Mon, Sep 28, 2009 at 3:53 PM, Kristleifur Da=C3=B0ason
>>>> <kristleifur@gmail.com> wrote:
>>>> > Hi again :)
>>>> >
>>>> > I forgot that I have the old mdadm 2.6.9 on this machine, so it'=
s
>>>> > probably
>>>> > not 100% the same; I did have 3.0.x but not currently, sorry abo=
ut that.
>>>> >
>>>> > The /etc/mdadm/mdadm.conf is probably copied automatically into =
the
>>>> > initramdisk when you have the Ubuntu package for mdadm, but I'm =
not sure
>>>> > what happens if you have a custom-built mdadm.
>>>> >
>>>> > I would guess that there is probably some config file for
>>>> > update-initramfs
>>>> > that tells it to take this and that file.
>>>> >
>>>> > Wish I could help you better.
>>>> >
>>>> > Have you tried expanding the updated initramfs and checking what=
 the
>>>> > mdadm.conf file in looks like?
>>>> >
>>>> > Good luck and by all means ask me any further questions you have=
!
>>>> >
>>>> > -- Kristleifur
>>>> >
>>>> > On Mon, Sep 28, 2009 at 12:36 PM, Aggelos Kyritsis
>>>> > <filodoksos@gmail.com>
>>>> > wrote:
>>>> >>
>>>> >> Thanks for the quick responce :-)
>>>> >>
>>>> >> I tried the "sudo update-initramfs -u -k all" command and it go=
t the
>>>> >> following two messages
>>>> >>
>>>> >> update-initramfs: Generating /boot/initrd.img-2.6.28-15-generic
>>>> >> update-initramfs: Generating /boot/initrd.img-2.6.28-11-generic
>>>> >>
>>>> >> But still no luck with the mdadm
>>>> >>
>>>> >> I have found a guide on creating a custom initial ramdisk
>>>> >> (http://www.ibm.com/developerworks/linux/library/l-initrd.html)=
 but it
>>>> >> still isn't clear to me how to place the mdadm.conf in it (and =
make
>>>> >> mdadm read the file).
>>>> >>
>>>> >> Could you please elaborate?
>>>> >>
>>>> >>
>>>> >>
>>>> >>
>>>> >> On Mon, Sep 28, 2009 at 12:18 PM, Kristleifur Da=C3=B0ason
>>>> >> <kristleifur@gmail.com> wrote:
>>>> >> > On Mon, Sep 28, 2009 at 7:13 AM, Aggelos Kyritsis
>>>> >> > <filodoksos@gmail.com>
>>>> >> > wrote:
>>>> >> >>
>>>> >> >> Dear sir/madam,
>>>> >> >>
>>>> >> >> I am running ubuntu 9.04. Until recently I used the mdadm ve=
rsion
>>>> >> >> that
>>>> >> >> exists in the ubuntu repositories, with perfect success. How=
ever,
>>>> >> >> since that version is fairly old (2.6, I think), I decided t=
o
>>>> >> >> install
>>>> >> >> the latest version 3.0.2.
>>>> >> >>
>>>> >> >> On a freshly formatted system with no mdadm I downloaded
>>>> >> >> http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.0.2=
=2Etar.gz,
>>>> >> >> unzipped it and run the "sudo make" and "sudo make install"
>>>> >> >> commands.
>>>> >> >> According to mdadm --version, I succesfuly installed version=
 3.0.2
>>>> >> >> of
>>>> >> >> the program. I was also successful on creating and mounting =
a fresh
>>>> >> >> raid 5 array.
>>>> >> >>
>>>> >> >> However, the installation didn't create either the
>>>> >> >> /etc/mdadm/mdadm.conf or the /etc/mdadm.conf file, where I n=
eed to
>>>> >> >> specify the array details so that it is assembled during boo=
t time.
>>>> >> >>
>>>> >> >> I manually created the mdadm.conf file in both locations and=
 added
>>>> >> >> the
>>>> >> >> "DEVICE partitions" line and a line with the result from mda=
dm
>>>> >> >> --examine --scan
>>>> >> >>
>>>> >> >> Even though this was enough on the old version of mdadm for =
auto
>>>> >> >> assemble during the boot sequence (so that /etc/fstab could =
mount
>>>> >> >> /dev/md0), on version 3.0.2 it made no diferrence at all, as=
 if the
>>>> >> >> mdadm I compiled and installed manually wouldn't read the
>>>> >> >> mdadm.config
>>>> >> >> file, neither on /etc/mdadm/mdadm.conf or on /etc/mdadm.conf
>>>> >> >>
>>>> >> >> Is there anything I could do to address this problem? Any wa=
y to
>>>> >> >> permanently point the mdadm to its mdadm.conf file? is there=
 an
>>>> >> >> mdadm.conf file created on some other location on the disk, =
where I
>>>> >> >> can add the array information?
>>>> >> >>
>>>> >> >> Thanks in advance
>>>> >> >>
>>>> >> >> Kind regards
>>>> >> >>
>>>> >> >> Angelos Kyritsis.
>>>> >> >
>>>> >> > Hi,
>>>> >> >
>>>> >> > I've tried almost exactly the same setup. I suspect that you =
may
>>>> >> > simply need to update the initramfs, specifically to place th=
e
>>>> >> > mdadm.conf in the init-ramdisk. Try "sudo update-initramfs -u=
 -k
>>>> >> > all".
>>>> >> > "-u" means update the initrd, "-k all" means to update for al=
l
>>>> >> > kernels.
>>>> >> >
>>>> >> > -- Kristleifur
>>>> >> >
>>>> >
>>>> >
>>>
>>>
>>
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
