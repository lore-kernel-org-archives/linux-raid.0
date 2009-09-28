From: Aggelos Kyritsis <filodoksos@gmail.com>
Subject: Re: mdadm 3.0.2 won't read mdadm.conf file
Date: Mon, 28 Sep 2009 21:13:54 +0300
Message-ID: <1e36c70e0909281113k44e4a032jc0940fe9f05d23eb@mail.gmail.com>
References: <1e36c70e0909280013o616d74draf419a548183cc7f@mail.gmail.com>
	 <1e36c70e0909280536s513fa655n9533efe220dceddf@mail.gmail.com>
	 <73e903670909280553t3de93c68t5673ba234ac72bef@mail.gmail.com>
	 <1e36c70e0909280652j42ee420mabaa4141363a976a@mail.gmail.com>
	 <73e903670909280704r1189e86aoc08cbc260e6d8ab8@mail.gmail.com>
	 <1e36c70e0909280714r2d81238dq198699a863be359e@mail.gmail.com>
	 <1e36c70e0909280748m160c190an453de1a773a96c48@mail.gmail.com>
	 <70ed7c3e0909280932h326730c4u2606044bbc6bce06@mail.gmail.com>
	 <1e36c70e0909280950o731c59a8t5f43b0d16382edc5@mail.gmail.com>
	 <70ed7c3e0909281047j618ca4feg1644c5f44b455e47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909281047j618ca4feg1644c5f44b455e47@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No, I just installed mdadm 3.0.2, rebooted and it worked

On Mon, Sep 28, 2009 at 8:47 PM, Majed B. <majedb@gmail.com> wrote:
> No I meant, did you update initramfs after installing mdadm 3.0.2,
> after you configured your array with the old version?
>
> You just mentioned that you used 2.6.7 to configure your array, then
> installed mdadm 3.0.2 <- after that, did you update initramfs?
>
> On Mon, Sep 28, 2009 at 7:50 PM, Aggelos Kyritsis <filodoksos@gmail.c=
om> wrote:
>> Yes, it was one of the first things I tried, as advised by
>> Kristleifur, and it didn't work.
>>
>>
>> On Mon, Sep 28, 2009 at 7:32 PM, Majed B. <majedb@gmail.com> wrote:
>>> Did you update initramfs after installing mdadm 3.0.2?
>>>
>>> On Mon, Sep 28, 2009 at 5:48 PM, Aggelos Kyritsis <filodoksos@gmail=
=2Ecom> wrote:
>>>> Well, I tried a simple and dirty solution (aren't they the best?) =
and it worked:
>>>>
>>>> On a fresh install of Ubuntu (I 'm a bit format-happy) I installed
>>>> mdadm version 2.6.7 (or something) from the repositories:
>>>> ------------
>>>>
>>>> sudo apt-get install mdadm
>>>>
>>>> sudo mdadm -A --scan
>>>>
>>>> sudo su
>>>>
>>>> mdadm --detail --scan >> /etc/mdadm/mdadm.conf
>>>>
>>>> gedit /etc/mdadm/mdadm.conf (made some corrections there, correcte=
d
>>>> metadata 00.90 to 0.90)
>>>>
>>>> mkdir /home/cthulhu/raid
>>>>
>>>> chown -R cthulhu:cthulhu /home/cthulhu/raid
>>>>
>>>> echo "/dev/md0 /home/cthulhu/raid auto defaults 0 3" >> /etc/fstab
>>>>
>>>> gedit /etc/fstab (to make sure it was correctly added)
>>>>
>>>> -----------
>>>>
>>>> Then I compiled version 3.0.2, reboot, and now the system correctl=
y
>>>> mounts the array on startup. Checked mdadm --version and it is ind=
eed
>>>> 3.0.2, 25 September 2009
>>>>
>>>> I 'm really curious, though, why the plain vanilla 3.0.2 installat=
ion
>>>> wouldn't work for me.
>>>>
>>>>
>>>> On Mon, Sep 28, 2009 at 5:14 PM, Aggelos Kyritsis <filodoksos@gmai=
l.com> wrote:
>>>>> Even if they are compiler flags, they are referring to the exact =
same
>>>>> file (mdadm.conf) that my mdadm 3.0.2 completely ignores. It migh=
t be
>>>>> a complete coincidence, but it does look suspicious, doesn't it?
>>>>>
>>>>> I resend the attachment for the list to see
>>>>>
>>>>> On Mon, Sep 28, 2009 at 5:04 PM, Kristleifur Da=F0ason
>>>>> <kristleifur@gmail.com> wrote:
>>>>>> Hi,
>>>>>>
>>>>>> it looks like we have actually started talking off-list :) (I th=
ink so at
>>>>>> least ...)
>>>>>>
>>>>>> Btw, Those "-Werror" things are compiler flags (it means "warn o=
n error") --
>>>>>> you're getting neither errors nor warnings there -- compilation =
is going
>>>>>> fine
>>>>>>
>>>>>> You'd better take this back to the list, there's probably smarte=
r people
>>>>>> than me there ... and maybe also try the Ubuntu forums
>>>>>>
>>>>>> -- Kristleifur
>>>>>>
>>>>>> On Mon, Sep 28, 2009 at 1:52 PM, Aggelos Kyritsis <filodoksos@gm=
ail.com>
>>>>>> wrote:
>>>>>>>
>>>>>>> I think I found the cause of the whole situation.
>>>>>>>
>>>>>>> During the compilation of mdadm 3.0.2 several error messages ap=
pear
>>>>>>> considering the mdadm.conf file.
>>>>>>>
>>>>>>> I attach a file with the compiler's output. I have a feeling th=
at if
>>>>>>> we can pinpoint the cause of those errors, the problem will be =
solved.
>>>>>>>
>>>>>>> Maybe my system is missing some compilation libraries? I have a=
lready
>>>>>>> installed the build-essential and gcc packages.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On Mon, Sep 28, 2009 at 3:53 PM, Kristleifur Da=F0ason
>>>>>>> <kristleifur@gmail.com> wrote:
>>>>>>> > Hi again :)
>>>>>>> >
>>>>>>> > I forgot that I have the old mdadm 2.6.9 on this machine, so =
it's
>>>>>>> > probably
>>>>>>> > not 100% the same; I did have 3.0.x but not currently, sorry =
about that.
>>>>>>> >
>>>>>>> > The /etc/mdadm/mdadm.conf is probably copied automatically in=
to the
>>>>>>> > initramdisk when you have the Ubuntu package for mdadm, but I=
'm not sure
>>>>>>> > what happens if you have a custom-built mdadm.
>>>>>>> >
>>>>>>> > I would guess that there is probably some config file for
>>>>>>> > update-initramfs
>>>>>>> > that tells it to take this and that file.
>>>>>>> >
>>>>>>> > Wish I could help you better.
>>>>>>> >
>>>>>>> > Have you tried expanding the updated initramfs and checking w=
hat the
>>>>>>> > mdadm.conf file in looks like?
>>>>>>> >
>>>>>>> > Good luck and by all means ask me any further questions you h=
ave!
>>>>>>> >
>>>>>>> > -- Kristleifur
>>>>>>> >
>>>>>>> > On Mon, Sep 28, 2009 at 12:36 PM, Aggelos Kyritsis
>>>>>>> > <filodoksos@gmail.com>
>>>>>>> > wrote:
>>>>>>> >>
>>>>>>> >> Thanks for the quick responce :-)
>>>>>>> >>
>>>>>>> >> I tried the "sudo update-initramfs -u -k all" command and it=
 got the
>>>>>>> >> following two messages
>>>>>>> >>
>>>>>>> >> update-initramfs: Generating /boot/initrd.img-2.6.28-15-gene=
ric
>>>>>>> >> update-initramfs: Generating /boot/initrd.img-2.6.28-11-gene=
ric
>>>>>>> >>
>>>>>>> >> But still no luck with the mdadm
>>>>>>> >>
>>>>>>> >> I have found a guide on creating a custom initial ramdisk
>>>>>>> >> (http://www.ibm.com/developerworks/linux/library/l-initrd.ht=
ml) but it
>>>>>>> >> still isn't clear to me how to place the mdadm.conf in it (a=
nd make
>>>>>>> >> mdadm read the file).
>>>>>>> >>
>>>>>>> >> Could you please elaborate?
>>>>>>> >>
>>>>>>> >>
>>>>>>> >>
>>>>>>> >>
>>>>>>> >> On Mon, Sep 28, 2009 at 12:18 PM, Kristleifur Da=F0ason
>>>>>>> >> <kristleifur@gmail.com> wrote:
>>>>>>> >> > On Mon, Sep 28, 2009 at 7:13 AM, Aggelos Kyritsis
>>>>>>> >> > <filodoksos@gmail.com>
>>>>>>> >> > wrote:
>>>>>>> >> >>
>>>>>>> >> >> Dear sir/madam,
>>>>>>> >> >>
>>>>>>> >> >> I am running ubuntu 9.04. Until recently I used the mdadm=
 version
>>>>>>> >> >> that
>>>>>>> >> >> exists in the ubuntu repositories, with perfect success. =
However,
>>>>>>> >> >> since that version is fairly old (2.6, I think), I decide=
d to
>>>>>>> >> >> install
>>>>>>> >> >> the latest version 3.0.2.
>>>>>>> >> >>
>>>>>>> >> >> On a freshly formatted system with no mdadm I downloaded
>>>>>>> >> >> http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.=
0.2.tar.gz,
>>>>>>> >> >> unzipped it and run the "sudo make" and "sudo make instal=
l"
>>>>>>> >> >> commands.
>>>>>>> >> >> According to mdadm --version, I succesfuly installed vers=
ion 3.0.2
>>>>>>> >> >> of
>>>>>>> >> >> the program. I was also successful on creating and mounti=
ng a fresh
>>>>>>> >> >> raid 5 array.
>>>>>>> >> >>
>>>>>>> >> >> However, the installation didn't create either the
>>>>>>> >> >> /etc/mdadm/mdadm.conf or the /etc/mdadm.conf file, where =
I need to
>>>>>>> >> >> specify the array details so that it is assembled during =
boot time.
>>>>>>> >> >>
>>>>>>> >> >> I manually created the mdadm.conf file in both locations =
and added
>>>>>>> >> >> the
>>>>>>> >> >> "DEVICE partitions" line and a line with the result from =
mdadm
>>>>>>> >> >> --examine --scan
>>>>>>> >> >>
>>>>>>> >> >> Even though this was enough on the old version of mdadm f=
or auto
>>>>>>> >> >> assemble during the boot sequence (so that /etc/fstab cou=
ld mount
>>>>>>> >> >> /dev/md0), on version 3.0.2 it made no diferrence at all,=
 as if the
>>>>>>> >> >> mdadm I compiled and installed manually wouldn't read the
>>>>>>> >> >> mdadm.config
>>>>>>> >> >> file, neither on /etc/mdadm/mdadm.conf or on /etc/mdadm.c=
onf
>>>>>>> >> >>
>>>>>>> >> >> Is there anything I could do to address this problem? Any=
 way to
>>>>>>> >> >> permanently point the mdadm to its mdadm.conf file? is th=
ere an
>>>>>>> >> >> mdadm.conf file created on some other location on the dis=
k, where I
>>>>>>> >> >> can add the array information?
>>>>>>> >> >>
>>>>>>> >> >> Thanks in advance
>>>>>>> >> >>
>>>>>>> >> >> Kind regards
>>>>>>> >> >>
>>>>>>> >> >> Angelos Kyritsis.
>>>>>>> >> >
>>>>>>> >> > Hi,
>>>>>>> >> >
>>>>>>> >> > I've tried almost exactly the same setup. I suspect that y=
ou may
>>>>>>> >> > simply need to update the initramfs, specifically to place=
 the
>>>>>>> >> > mdadm.conf in the init-ramdisk. Try "sudo update-initramfs=
 -u -k
>>>>>>> >> > all".
>>>>>>> >> > "-u" means update the initrd, "-k all" means to update for=
 all
>>>>>>> >> > kernels.
>>>>>>> >> >
>>>>>>> >> > -- Kristleifur
>>>>>>> >> >
>>>>>>> >
>>>>>>> >
>>>>>>
>>>>>>
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>>
>>>
>>> --
>>> =A0 =A0 =A0 Majed B.
>>>
>>
>
>
>
> --
> =A0 =A0 =A0 Majed B.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
