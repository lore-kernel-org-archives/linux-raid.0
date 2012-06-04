From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Sun, 03 Jun 2012 20:55:04 -0500
Message-ID: <4FCC1578.50801@hardwarefreak.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com> <20120601192524.GH3867@bitfolk.com> <4FC9A8D4.9060803@hardwarefreak.com> <20120603033042.GI3867@bitfolk.com> <CA+sTkh49kYa=sqzSNhnQtjMTs7OL=kmpsoP55k1zifFVByzENw@mail.gmail.com> <20120603220536.GN3867@bitfolk.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120603220536.GN3867@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/3/2012 5:05 PM, Andy Smith wrote:
> Hi Igor,
>=20
> On Sun, Jun 03, 2012 at 12:05:31PM +0800, Igor M Podlesny wrote:
>> On 3 June 2012 11:30, Andy Smith <andy@strugglers.net> wrote:
>>> I probably didn't give enough details. On this particular host ther=
e
>>> are four md arrays:
>>>
>>> md0 is mounted as /boot
>>> md1 is used as swap
>>> md2 is mounted as /
>>> md3 is an LVM PV for "everything else"
>> [=85]
>>
>>    Kinda off-topic question =97 why having separate MDs for swap and
>> root? I mean LVM's lv would be just fine for them.
>=20
> I know, but I'm kind of old-fashioned and have some (probably
> unwarranted) distrust of having the really essential bits of the
> system in LVM if they don't really need to be.

I wouldn't say unwarranted.  I've seen instances on this and other list=
s
where an md array blew chunks, was repaired and everything reported
good, only to have LVM devices corrupted beyond repair.  Or both md and
LVM report good after repair, but the XFS superblock is hosed beyond
repair.  The layers in the storage stack the better.  KISS principle,
"Just because you can doesn't mean you should", etc, etc.

> The system needs swap and I'm unlikely to want to change the size of
> that swap, but if I do I can just add more swap from inside LVM. / is
> also unlikely to need to be resized ever, so I keep that outside of
> LVM too.
>=20
> My position on this is probably going to have to change given the
> current "get rid of /usr" plans that seem to be gaining traction in
> the Linux community. A beefier / would probably justify being in
> LVM to me.

I guess I'm more old fashioned.  I'd never put the root filesystem on a=
n
LVM volume.  My preferences are directly on a single disk partition, or
hardware RAID1 partition, depending on the server/application area.

> But really it is all just personal taste isn't it..

To an extent yes.  Separating different portions of the UNIX filesystem
tree on different partitions/devices has a long tradition and usually
good reasoning behind it.  However, as I mentioned, spreading these
across multiple md arrays that share the same physical disks is not a
good idea.  A single md array with multiple partitions, with the
filesystem tree, swap, and data directories spread over these
partitions, is preferable.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
