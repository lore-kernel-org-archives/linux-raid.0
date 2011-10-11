From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Tue, 11 Oct 2011 15:11:47 +0200
Message-ID: <CAGRgLy6Ew-mDK-u+Gz9Ae8gKzjC+qJBxM_=Xm6x=VBJBPeOaeg@mail.gmail.com>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
	<CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
	<20110921150323.0ef402c9@notabene.brown>
	<CAGRgLy7fKegKw6j-36o0uchTF35F4hT8NvujW4ghb5av-onCGQ@mail.gmail.com>
	<20110925201510.24e0f468@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110925201510.24e0f468@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,
can you please confirm for me something?
In case the array is FAILED (when your enough() function returns 0) -
for example, after simultaneous failure of all drives - then the only
option to try to recover such array is to do:
mdadm --stop
and then attempt
mdadm --assemble

correct?

I did not see any other option to recover such array Incremental
assemble doesn't work in that case, it simply adds back the drives as
spares.

Thanks,
  Alex.

On Sun, Sep 25, 2011 at 12:15 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 23 Sep 2011 22:24:08 +0300 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Thank you, Neil, for answering.
>> I'm not sure that understand all of this, because my knowledge of
>> Linux user-kernel interaction is, unfortunately, not sufficient. In
>> the future, I hope to know more.
>> For example, I don't understand, how opening a "/dev/mdXX" can creat=
e
>> a device in the kernel, if the devnode "/dev/mdXX" does not exist. I=
n
>> that case, I actually fail to open it with ENOENT.
>
> /dev/mdXX is a "device special file". =A0It is not the device itself.
> You can think of it like a symbolic link.
> The "real" name for the device is something like "block device with m=
ajor 9
> and minor X" =A0That thing can exist quite independently of whether
> the /dev/mdXX thing exists. =A0Just like a file may or may not exist
> independently of whether some sym-link to it exists.
>
> When the device (block,9,XX) appears, udev is told and it should crea=
te
> things in /dev. =A0when the device disappears, udev is told and it sh=
ould
> remove the /dev entry. =A0But there can be races, and other things mi=
ght
> sometimes add or remove /dev entries (though they shouldn't). =A0So t=
he
> existence of something in /dev isn't a guarantee that it really exist=
s.
>
>
>>
>> But what I did is actually similar to what you advised:
>> - if I fail to open the devnode with ENOENT, I know (?) that the
>> device does not exist
>> - otherwise, I do GET_ARRAY_INFO
>> - if it returns ok, then I go ahead and do GET_DISK_INFOs to get the
>> disks information
>> - otherwise if it returns ENODEV, I close the fd and then I read /pr=
oc/mdstat
>> - if the md is there, then I know it's inactive array (and I have to
>> --stop it and reassemble or do incremental assembly)
>> - if the md is not there, then I know that it really does not exist
>> (this is the case when md deletion happened but the devnode did not
>> disappear yet)
>>
>> Does it sound right? It passes stress testing pretty well.
>
> Yes, that sounds right.
>
>>
>> By the way, I understand that /proc/mdstat can be only of 4K size...=
so
>> if I have many arrays, I should probably switch to look at
>> /sys/block....
>
> Correct.
>
> NeilBrown
>
>
>>
>> Thanks,
>> =A0 Alex.
>>
>>
>>
>>
>>
>>
>> On Wed, Sep 21, 2011 at 8:03 AM, NeilBrown <neilb@suse.de> wrote:
>> >
>> > On Tue, 13 Sep 2011 11:49:12 +0300 Alexander Lyakas <alex.bolshoy@=
gmail.com>
>> > wrote:
>> >
>> > > Hello Neil,
>> > > I am sorry for opening this again, but I am convinced now that I=
 don't
>> > > understand what's going on:)
>> > >
>> > > Basically, I see that GET_ARRAY_INFO can also return ENODEV in c=
ase
>> > > the device in the kernel exists, but "we are not initialized yet=
":
>> > > /* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
>> > > =A0* RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
>> > > if ((!mddev->raid_disks && !mddev->external)
>> > > =A0 =A0 && cmd !=3D ADD_NEW_DISK && cmd !=3D STOP_ARRAY
>> > > =A0 =A0 && cmd !=3D RUN_ARRAY && cmd !=3D SET_BITMAP_FILE
>> > > =A0 =A0 && cmd !=3D GET_BITMAP_FILE) {
>> > > =A0 =A0 =A0 err =3D -ENODEV;
>> > > =A0 =A0 =A0 goto abort_unlock;
>> > >
>> > > I thought that ENODEV means that the device in the kernel does n=
ot
>> > > exist, although I am not this familiar with the kernel sources (=
yet)
>> > > to verify that.
>> > >
>> > > Basically, I just wanted to know whether there is a reliable way=
 to
>> > > determine whether the kernel MD device exists or no. (Obviously,
>> > > success to open a devnode from user space is not enough).
>> > >
>> > > Thanks,
>> > > =A0 Alex.
>> >
>> > What exactly do you mean by "the kernel MD device exists" ??
>> >
>> > When you open a device-special-file for an md device (major =3D=3D=
 9) it
>> > automatically creates an inactive array. =A0You can then fill in t=
he details
>> > and activate it, or explicitly deactivate it. =A0If you do that it=
 will
>> > disappear.
>> >
>> > Opening the devnode is enough to check that the device exists, bec=
ause it
>> > creates the device and then you know that it exists.
>> > If you want to know if it already exists - whether inactive or not=
 - look
>> > in /proc/mdstat or /sys/block/md*.
>> > If you want to know if it already exists and is active, look in /p=
roc/mdstat,
>> > or open the device and use GET_ARRAY_INFO, or look in /sys/block/m=
d*
>> > and look at the device size. or maybe /sys/block/mdXX/md/raid_disk=
s.
>> >
>> > It depends on why you are asking.
>> >
>> > NeilBrown
>> >
>> >
>> >
>> > >
>> > >
>> > >
>> > >
>> > >
>> > >
>> > >
>> > > On Tue, Aug 30, 2011 at 12:25 AM, NeilBrown <neilb@suse.de> wrot=
e:
>> > > > On Mon, 29 Aug 2011 20:17:34 +0300 Alexander Lyakas <alex.bols=
hoy@gmail.com>
>> > > > wrote:
>> > > >
>> > > >> Greetings everybody,
>> > > >>
>> > > >> I issue
>> > > >> mdadm --stop /dev/md0
>> > > >> and I want to reliably determine that the MD devnode (/dev/md=
0) is gone.
>> > > >> So I look for the udev 'remove' event for that devnode.
>> > > >> However, in some cases even after I see the udev event, I iss=
ue
>> > > >> mdadm --detail /dev/md0
>> > > >> and I get:
>> > > >> mdadm: md device /dev/md0 does not appear to be active
>> > > >>
>> > > >> According to Detail.c, this means that mdadm can successfully=
 do
>> > > >> open("/dev/md0") and receive a valid fd.
>> > > >> But later, when issuing ioctl(fd, GET_ARRAY_INFO) it receives=
 ENODEV
>> > > >> from the kernel.
>> > > >>
>> > > >> Can somebody suggest an explanation for this behavior? Is the=
re a
>> > > >> reliable way to know when a MD devnode is gone?
>> > > >
>> > > > run "udevadm settle" after stopping /dev/md0 =A0is most likely=
 to work.
>> > > >
>> > > > I suspect that udev removes the node *after* you see the 'remo=
ve' event.
>> > > > Sometimes so soon after that you don't see the lag - sometimes=
 a bit later.
>> > > >
>> > > > NeilBrown
>> > > >
>> > > >>
>> > > >> Thanks,
>> > > >> =A0 Alex.
>> > > >> --
>> > > >> To unsubscribe from this list: send the line "unsubscribe lin=
ux-raid" in
>> > > >> the body of a message to majordomo@vger.kernel.org
>> > > >> More majordomo info at =A0http://vger.kernel.org/majordomo-in=
fo.html
>> > > >
>> > > >
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-=
raid" in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
>> >
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
