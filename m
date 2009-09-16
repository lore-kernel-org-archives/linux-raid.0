From: "Majed B." <majedb@gmail.com>
Subject: Re: Assemble and Stop array
Date: Wed, 16 Sep 2009 19:14:01 +0300
Message-ID: <70ed7c3e0909160914m3d1fabd4qbfc0084033e17614@mail.gmail.com>
References: <816534d7bc3fe604e11760fbf33932d1.squirrel@neil.brown.name>
	<20090916150703425.XXDI6569@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090916150703425.XXDI6569@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You mentioned that lsof doesn't show open files, but what about directo=
ries?

If you have a shell open and is inside a directory of the mounted
filesystem, the filesystem can't be unmounted.
The same would happen if you run a program from the shell from that
filesystem and that program isn't close before attemtping umount.

I used to get similar symptoms (unable to mount) but on normal
partitions (no arrays) when I had Slackware 9.0 (2.4 kernel & using
hotplug, not udev). The problem went away after I compiled a newer
kernel 3 months later.

I would suggest that you execute "sync" to make sure whatever in the
disks' cache is written to the filesystem before unmounting to avoid
data corruption or inconsistency.

On Wed, Sep 16, 2009 at 6:06 PM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> > fails with a device busy error. =C2=A0Every time it has happened, =
a simple
>> > umount
>> > command without the -l switch fails, but a "lazy" umount appears t=
o
>> work,
>> > with the exception that sometimes I still cannot stop the array.
>> Clearly,
>> > the NFS export is sometimes the culprit, but not always. =C2=A0Wha=
t else can
>> it
>> > be?
>>
>> It's best not to use --lazy if yo really want to stop the array.
>> It makes it harder to find the problem.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Well, OK. =C2=A0I always try an ordinary u=
mount first, but when it fails,
> sometimes a lazy umount works.
>
>> You seem to have covered everything that I can think of that would
>> keep a filesystem active...
>>
>> >
>> > =C2=A0 =C2=A0 The second item is assembling an array which was for=
merly stopped.
>> > By my reading, `mdadm --assemble --scan` should work, but it doesn=
't.
>> It
>> > keeps telling me no devices are found for the array. =C2=A0Here is=
 a sample
>> > from
>> > one of the /etc/mdadm/mdadm.conf files:
>> >
>>
>> Try adding --verbose to the "mdadm --assemble" line. =C2=A0If that d=
oesn't
>> give you any hints, post the output and it might give me some hints.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OK, thanks. =C2=A0The next time it happens=
, I will.
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
