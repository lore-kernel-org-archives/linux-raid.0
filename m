From: David Brown <david@westcontrol.com>
Subject: Re: raid1 mirror optimizations
Date: Wed, 26 Jan 2011 10:49:50 +0100
Message-ID: <ihoqek$nu4$1@dough.gmane.org>
References: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/01/2011 19:56, Roberto Spadim wrote:
> hi guys... i have a damaged disk...
> i=B4m using raid1
> the computer crashed with the floor :P hihiih sorry, but the disks ar=
e
> damaged at the same position
> check: http://www.spadim.com.br/hd%20agra.zip
> the problem: since raid1 (mirror) is done with real mirror, the disk
> position are the same...
> if i was using a mirror but on disk 1 i write from beggining to end,
> and disk 2 from end to beggining , i don=B4t crash the disk at the sa=
me
> position, for disk 1 i crash it some bytes, for disk 2 i crash some
> others bytes, since beggining is a small cilinder and end a bigger, i
> could loose less information than mirror
> could we implement a 'inverted' mirror? just for hard disks (for ssd
> it=B4s a small loss of cpu/memory)
> thanks
>

If you are worried about the disks being in the same position, then I=20
assume you mean the heads were in the same position when they crashed=20
into the disk.  If that's the case, then it doesn't really matter too=20
much if the same bytes on the disk were hit - your disks are trashed=20
anyway, and you'll need expensive professional recovery services to dea=
l=20
with it.

If you are not talking about head crashes, and merely about corruption=20
because the disks were being written to in the same place on both disks=
,=20
then the layout on the disk will make little difference - the same data=
=20
will be written to the same logical place at roughly the same time.  It=
=20
doesn't matter where this data is located physically on the disk, since=
=20
it is the data that matters.  The same thing actually applies to head=20
crashes too.

If you really want an "inverted" mirror, there is an easy way to get=20
much of the same effect.  Instead of setting up raid1, use raid10 with=20
"far 2" positioning.  The effect is roughly like this:

disk1 (stripe 1) (mirror of stripe 2)
disk2 (stripe 2) (mirror of stripe 1)

So the two copies of the data are in different physical positions on=20
each disk.  It's not a full reversal, but you can think of disk 2 as=20
being split in two and its two halves swapped.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
