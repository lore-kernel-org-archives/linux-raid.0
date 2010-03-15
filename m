From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID1 On 3 Drives
Date: Mon, 15 Mar 2010 15:48:44 +0300
Message-ID: <70ed7c3e1003150548v65dce098ud62ddfbcc0747d49@mail.gmail.com>
References: <4B9C11FB.7040604@gmx.net> <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com>
	<4B9C24B6.7040507@tmr.com> <d80f793f1003150530y1b229f43s1f140f91ab74f3e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1003150530y1b229f43s1f140f91ab74f3e8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Carlos,

Choosing your RAID setup depends on the purpose of your machine. Is it
a web server, file server, archive, mail, video storage, ...etc.?

/boot is only used during boot up. Having a spare on stand by or not
does not affect performance, except in the case a disk dies; in that
case, the hot spare is engaged and becomes an active disk at which the
array starts to resync the data to this new disk. During resyncing,
performance will be degraded.

Including all disks in the array (no spare) means data is being
written in parallel to all disks at all times. You'd still have to
replace a dead disk and add it to the array and it will still have to
resync.

As for your RAID5 question: I think if your usage of the server is
write-mostly, you may find it to have better performance with 3 disks
rather 4. If it's read-mostly, then 4 disks should perform better.

If you have physical access to the machine, try both cases. Setting
them up won't take more than 5-10 minutes. Benchmarking wouldn't take
more than 15 minutes in each setup.

Remember, there are parameters to fine-tune: NCQ, read-ahead, noatime,
nodiratime, chunksize, ...etc.

On Mon, Mar 15, 2010 at 3:30 PM, Carlos Mennens <carloswill@gmail.com> =
wrote:
> On Sat, Mar 13, 2010 at 6:50 PM, Bill Davidsen <davidsen@tmr.com> wro=
te:
>> Having a spare on raid-1 is fairly pointless, it hurts performance a=
nd buys
>> you nothing. Having one more copy of the data built and ready serves=
 you
>> better.
>
> Can you explain this as I find this interesting. How does having a
> /boot partition on 3 drives with 1 spare hurt performance? Are you
> saying that I would get better drive performance if I had all 4 disk
> partitions active members of my RAID1 /boot? I just don't understand
> how the 4th disk doing nothing but acting as a spare would hinder
> performance.
>
> Secondly, if the above statement also applies to my / partition? Woul=
d
> you suggest using all 4 drives as active partitions in a RAID5 array
> too? If I have a 3 disk RAID5 and one hot spare, do you think I would
> get less performance value for my configuration?
>
> Thanks for the clarification!
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
