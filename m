From: hansbkk@gmail.com
Subject: Re: LVM over RAID, or plain disks? A:"Yes" = best of both worlds?
Date: Mon, 29 Nov 2010 18:01:11 +0700
Message-ID: <AANLkTinUmZoqSWNZ7NK+tg5DTpc5JFbbPPZV6YONq+ox@mail.gmail.com>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
	<2D.98.07087.690A2FC4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2D.98.07087.690A2FC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Mon, Nov 29, 2010 at 1:34 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> - I am not at this point overly concerned about performance issues -
>> reliability/redundancy and ease of recovery are my main priorities.
>
> =A0 =A0 =A0 =A0In that case, I'm not sure about your desire for the a=
dditional
> complexity. =A0Someone else suggested RAID6, which from an operationa=
l
> standpoint is much simpler. =A0The main reason, it seems to me, for t=
he more
> complex topologies would be enhancing perfromance.

I can see how RAID6 is simpler than RAID10, but compared to RAID1?

>> The mirroring at the top level would be set up between the individua=
l
>> LVs on the TopRAID1 side and regular filesystem partitions (no RAID =
or
>> LVM) on the TopRAID2 side. In the event of a massive host failure, t=
he
>> filesystems on the TopRAID2 side could be easily mounted for data
>> recovery and/or service resumption on another machine, and the
>> TopRAID1 disk set rebuilt from scratch and then re-mirrored from the
>> TopRAID2 disks.
>
> =A0 =A0 =A0 =A0This will certainly work. =A0Let me ask you this: =A0W=
hat advantage do
> you seek from using LVM on side 1? =A0Growth? =A0Re-sizing?

It's a filer, servicing an ever-changing mix of dozens of clients
(from a storage POV, both clients and servers), possibly using iSCSI,
definitely samba and nfs. Creating new shares and/or iSCSI targets or
re-configuring existing ones can't interfere with the operations of
the other hosts. I can't see doing this without LVM myself. I'm likely
to implement this with Openfiler, and in fact I believe it's
install/configuration routines force the use of LVM for exactly this
reason.

>> One design goal would be to not allow any LV to get so large that it
>> won't fit on a single physical disk on the TopRAID2 side. If this is
>> not possible, then the corresponding TopRAID2 side would need to
>> comprise a multiple disk set, perhaps striped by RAID0 - not as
>> straightforward to recover as single disks, but at least without the
>> LVM layer.
>
> =A0 =A0 =A0 =A0To my mind, a solution which assumes the data payload =
will not
> exceed a certain physical size is poorly considered unless the server=
 hosts
> only a very specific application whose data extents are specifically =
limited
> by the application itself. =A0The beauty, as it were, of LVM is that =
it can
> easily accommodate changing space needs within a pool of available st=
orage
> space. =A0If there are strict limits on the payload size, then I'm no=
t certain
> how LVM would offer advantages, especially if you are disallowing str=
iping
> the volumes.

Sorry I wasn't more clear. I'm using LVM on the TopRAID1 side for
exactly this reason. The TopRAID2 side is simply to enable cloning a
given LV to a straightforward partition for easy disaster recovery.

If and when a given LV needs to be resized, I would break the RAID1 to
the TopRAID2 beforehand and manually prepare an appropriate new
"static" target on the TopRAID1 side and then re-mirror.

> =A0 =A0 =A0 =A0What you are proposing can certainly be done, but it s=
ounds awfully
> frail, to me. =A0I think a better solution would be to be a RAID1 mir=
ror of
> every volume - each volume being a RAID or LVM of some number of disk=
s, with
> no disk being host to more than one volume on either side. =A0Then, r=
ather
> than failing an element, you can fail the entire volume set, stop the=
 volume
> and take all the disks offline at once. =A0Not only that, but if I we=
re you, I
> would make it a 3 volume mirror, keeping at least 2 volumes online at=
 one
> time. =A0Given your need to rotate the entire volume set, I don't bel=
ieve
> RAID10 will be ideal for what you want, but if not a relatively simpl=
e
> matrix of RAID0 and RAID1 should work. =A0I'm not all that familiar w=
ith
> RAID10, though, so one of the more expert members of the list may wan=
t to
> chime in.

> =A0 =A0 =A0 =A0It sounds practical to me in terms of setting it up, b=
ut not in
> terms of being reliable, given the way you intend to use it.

Yes, I see that I shouldn't rely on the TopRAID2 side for reliability,
and now plan to make the TopRAID1 side reliable in and of itself, and
of course am also taking frequent backups.

This now allows me to consider the TopRAID2 side as "expendable" only
for the purpose of cloning a given LV to a straightforward partition,
and I can test and experiment as I like.

It would certainly be more conventional to just use a partition
cloning tool like Acronis or BESR to make a copy of an LVM snapshot
into a file; I was hoping I could use mdm instead to allow me to take
normal partitions offsite ready to mount, rather than filesystems
needing a restore procedure.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
