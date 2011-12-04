From: Kenneth Emerson <kenneth.emerson@gmail.com>
Subject: Re: md metadata nightmare
Date: Sun, 4 Dec 2011 11:20:01 -0600
Message-ID: <CADzwnhW+o69Dum10biobv8r093uUa+LABv71Jdg+obOt5Ev6+A@mail.gmail.com>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
	<20111123114743.1085889e@notabene.brown>
	<CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
	<20111124093637.0c3bb2eb@notabene.brown>
	<CADzwnhXuW7ShBNGf+kqnZYrtRnWMPSRDWzb2h4Gt69Cih0-yGA@mail.gmail.com>
	<20111204061122.5bb5de4b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111204061122.5bb5de4b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 3, 2011 at 1:11 PM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 3 Dec 2011 10:58:43 -0600 Kenneth Emerson <kenneth.emerson@gm=
ail.com>
> wrote:
>
>> >
>> > > I will do this conversion; but I will backup my data as best I c=
an first,
>> > > just in case.
>> > > I still have the 5 1TB drives and my data should fit on there, j=
ust a PIA
>> > > to do it.
>> > > (Ahh, that's what weekends are for, right?)
>> > > After the RAID6 is repaired and running OK, I believe I will reb=
uild the
>> > 2
>> > > RAID1 arrays
>> > > as that will be an easy project (since I have 5 copies of everyt=
hing)
>> > which
>> > > will get rid of
>> > > all vestiges of previous raid arrays. =A0Do I need to anything s=
pecial
>> > other
>> > > than zeroing
>> > > the superblocks (--zero-superblock)? =A0Also, shouldn't I do tha=
t on the
>> > > RAID6 array before
>> > > doing the create or is that done automagically?
>> >
>> > It is done automatically. =A0When you use "--create", mdadm will z=
ero any
>> > superblocks it finds of any format that it recognises, then write =
the new
>> > metadata it wants.
>> >
>> > I am still waiting for my replacement Hitachi drive. My RAID6
>> configuration is made up of a total of 5 drives and I am currently r=
unning
>> degraded (missing one drive). =A0Can I recreate this raid set, chang=
ing the
>> metadata version missing one drive or should I just be patient and w=
ait for
>> the replacement to arrive?
>>
>> -- Ken Emerson
>
> Yes, you can re-create the raid set as degraded.
> When you list the devices in the "mdadm --create" command, use the wo=
rd
> "missing" for the device which is missing.
>
> NeilBrown

So I finished my backup and attempted to recreate the array using:

root@mythtv:/home/ken# mdadm -C /dev/md3 --metadata=3D1.0 --chunk=3D64k
--level=3D6 --raid-devices=3D5 missing /dev/sdb4 /dev/sdc4 /dev/sda4
/dev/sdd4 --assume-clean

and received the error:

mdadm: invalid chunk/rounding value: 64k

What do I do now?

-- Ken E.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
