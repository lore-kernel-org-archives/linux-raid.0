From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: fsck problems. Can't restore raid
Date: Mon, 28 Dec 2009 18:46:09 -0800
Message-ID: <4877c76c0912281846g4b678d48ue518a7c39094613@mail.gmail.com>
References: <1261939285.10448.3328.camel@vibe>
	 <28.16.07989.EE3E73B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28.16.07989.EE3E73B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Rick Bragg <lists@gmnet.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Dec 27, 2009 at 2:47 PM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> On Sun, 2009-12-27 at 00:13 -0600, Leslie Rhorer wrote:
>> > > # mdadm --examine /dev/sdb1
>> > > mdadm: No md superblock detected on /dev/sdb1.
>> > >
>> > > (Does this mean that sdb1 is bad? or is that OK?)
>> >
>> > =A0 =A0 It doesn't necessarily mean the drive is bad, but the supe=
rblock is
>> > gone. =A0Are you having mdadm monitor your array(s) and send infor=
mational
>> > messages to you upon RAID events? =A0If not, then what may have ha=
ppened
>> is
>> > you lost the superblock on sdb1 and at some other time - before or=
 after
>> -
>> > lost the sda drive. =A0Once both events had taken place, your arra=
y is
>> toast.
>> Right, I need to set up monitoring...
>
> =A0 =A0 =A0 =A0Um, yeah. =A0A RAID array won't prevent drives from go=
ing up in smoke,
> and if you don't know a drive has failed, you won't know you need to =
fix
> something - until a second drive fails.
>
>> > =A0 =A0 All may not be lost, however. =A0First of all, take care w=
hen
>> > re-arranging not to lose track of which drive was which at the out=
set.
>> In
>> > fact, other than the sda drive, you might be best served not to mo=
ve
>> > anything. =A0Take special care if the system re-assigns drive lett=
ers, as
>> it
>> > can easily do.
>> So should I just "move" the A drive? and try to fire it back up?
>
> =A0 =A0 =A0 =A0At this point, yeah. =A0Don't lose track of from where=
 and to where it
> has been moved, though.
>
>> > =A0 =A0 What are the contents of /etc/mdadm.conf?
>> >
>>
>> mdadm.conf contains this:
>> ARRAY /dev/md0 level=3Draid10 num-devices=3D4
>> UUID=3D3d93e545:c8d5baec:24e6b15c:676eb40f
>
> =A0 =A0 =A0 =A0Yeah, that doesn't help much.
>
>> So, by re-creating, do you mean I should try to run the "mdadm --cre=
ate"
>> command again the same way I did back when I created the array
>> originally? Will that wipe out my data?
>
> =A0 =A0 =A0 =A0Not in and of itself, no. =A0If you get the drive orde=
r wrong
> (different than when it was first created) and resync or write to the=
 array,
> then it will munge the data, but all creating the array does is creat=
e the
> superblocks.
>
>
>> # smartctl -l selftest /dev/sda
>> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce=
 Allen
>> Home page is http://smartmontools.sourceforge.net/
>>
>> Standard Inquiry (36 bytes) failed [No such device]
>> Retrying with a 64 byte Standard Inquiry
>> Standard Inquiry (64 bytes) failed [No such device]
>> A mandatory SMART command failed: exiting. To continue, add one or m=
ore '-
>> T permissive' options.
>
> =A0 =A0 =A0 =A0Well, we kind of knew that. =A0Either the drive is dea=
d, or there is a
> hardware problem in the controller path. =A0Hope for the latter, alth=
ough a
> drive with a frozen platter can sometimes be resurrected, and if the =
drive
> electronics are bad but the servo assemblies are OK, replacing the
> electronics is not difficult. =A0Otherwise, it's a goner.
>
>> # smartctl -l selftest /dev/sdb
>> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce=
 Allen
>> Home page is http://smartmontools.sourceforge.net/
>>
>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
>> SMART Self-test log structure revision number 1
>> Num =A0Test_Description =A0 =A0Status =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0Remaining
>> LifeTime(hours) =A0LBA_of_first_error
>> # 1 =A0Extended offline =A0 =A0Completed: read failure =A0 =A0 =A0 9=
0% =A0 =A0 =A07963
>> 543357
>
> =A0 =A0 =A0 =A0Oooh! =A0That's bad. =A0Really bad. =A0Your earlier po=
st showed the
> superblock is a 0.90 version. =A0The 0.90 superblock is stored near t=
he end of
> the partition. =A0Your drive is suffering a heart attack when it gets=
 near the
> end of the drive. =A0If you can't get your sda drive working again, t=
hen I'm
> afraid you've lost some data, maybe all of it. =A0Trying to rebuild a
> partition from scratch when part of it is corrupted is not for the fe=
int of
> heart. =A0If you are lucky, you might be able to dd part of the sdb d=
rive onto
> a healthy one and manually restore the superblock. =A0That, or since =
the sda
> drive does appear in /dev, you might have some luck copying some of i=
t to a
> new drive.
>
> =A0 =A0 =A0 =A0Beyond that, you are either going to need the advice o=
f someone who
> knows much more about md and Linux than I do, or else the services of=
 a
> professional drive recovery expert. =A0They don't come cheap.
>
>> This is strange, now I am getting info from mdadm --examine that is
>> different than before...
>
> =A0 =A0 =A0 =A0It looks like sda may be responding for the time being=
=2E =A0I suggest
> you try to assemble the array, and if successful, copy whatever data =
you can
> to a backup device. =A0Do not mount the array as read-write until you=
 have
> recovered everything you can. =A0If some data is orphaned, it might b=
e in the
> lost+found directory. =A0If that's successful, I suggest you find out=
 why you
> had two failures and start over. =A0I wouldn't use a 0.90 superblock,=
 though,
> and you definitely want to have monitoring enabled.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

If you have the spare drives/space I -highly- recommend dd_rescue /
ddrescue copying the suspected-bad drives contents to clean drives.
http://www.linuxfoundation.org/collaborate/workgroups/linux-raid/raid_r=
ecovery
has a script to try out the combinations so you can see where the
least data is lost.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
