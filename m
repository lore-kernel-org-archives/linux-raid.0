From: =?UTF-8?Q?Lucian_=C8=98andor?= <lucisandor@gmail.com>
Subject: Re: RAID5 demise or coma? after re-creating with a spare
Date: Sun, 6 Dec 2009 06:00:40 -0500
Message-ID: <c775b4470912060300t1c1ea881k8d632571f1c38e9@mail.gmail.com>
References: <c775b4470912041146rcff477bj97e86eca5bdb2dfa@mail.gmail.com>
	<20091205081231.22625302@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091205081231.22625302@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/12/4 Neil Brown <neilb@suse.de>:
> On Fri, 4 Dec 2009 14:46:39 -0500
> Lucian =C8=98andor <lucisandor@gmail.com> wrote:
>
>> Hi all,
>> There is a problem with my Linux installation, and the drives get
>> renamed and reordered all the time. Now, it just happened that the t=
wo
>> degraded RAID5s won't return to life. The system would not boot, so =
I
>> panicked and deleted: fstab, mdadm.conf, and some of the superblocks=
=2E
>> Now Linux boots, but RAIDs are, of course, dead. I tried to re-creat=
e
>> the arrays, but I cannot recall the correct order and my attempts
>> failed. I believe that the partitions are OK, because I don't recall
>> re-creating without "missing", but surely the superblocks are damage=
d
>> and certanily most of them are zero now.
>> Is there a short way to recover the degraded RAIDs without knowing t=
he
>> order of drives? I have 6 drives in one (including "missing"), that
>> gives 720 permutations. Also, clearing the superblocks is recoverabl=
e,
>> isn't it?
>
> Yes, 720 permutations. =C2=A0But you can probably write a script
> to generate them all ... how good are your programming skills?
> Use "--assume-clean" to create the array so that it doesn't
> auto-resync. =C2=A0Then "fsck -n" to see of the data is even close
> to correct.
>
> And why would you think that erasing the superblocks is a recoverable
> operation? =C2=A0It isn't.
>
> NeilBrown
>

Thanks for your reply.

I didn't realize why googling "recovery after zero superblock" was so
inefficient. Sounds very very troubling.

I will script it then for the one array with non-zeroes superblocks.
One issue is that I didn't use -assume-clean in my early attempts of
re-creation. I know this overwrites the superblock. Didn't it make my
superblocks as useless as if I zeroed them?

Thanks,
Lucian Sandor
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
