From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Raid 10 LVM JFS Seeking performance help
Date: Mon, 21 Dec 2009 13:56:44 +0100
Message-ID: <87hbrko583.fsf@frosties.localdomain>
References: <7eea85cf0912171549u58a4c64foc4cb96a388ddbd06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7eea85cf0912171549u58a4c64foc4cb96a388ddbd06@mail.gmail.com>
	(Chris's message of "Thu, 17 Dec 2009 15:49:18 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Chris <cmtimegn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris <cmtimegn@gmail.com> writes:

> I have a pair of servers serving 10MB-100MB files.=C2=A0 Each server =
has
> 12x 7200 SaS 750GB Drives.=C2=A0 When I look at iostat I see the avgr=
q-sz
> is 8.0 always.=C2=A0 I think this has to do with the fact my LVM PE S=
ize is
> 4096 with JFS on top of that.=C2=A0=C2=A0=C2=A0 Best I can tell the f=
act I have so
> many rrqm/s is not great and the reason I have that many is because m=
y
> avgrq-sz is 8.0.=C2=A0 I have been trying to grasp how I should come =
up
> with the best chunk and PE for more performance.
>
> Switch from n2 to f2 raid10?
> How do I calculate where I need to go from here with Chunk Size and P=
E size?

2 far copies means each disk is split into 2 partitions, lets call
them sda1/2, sdb1/2, ... Then sda1, sdb2 form a raid1 (md1) and sdb1,
sdc2 form a second raid1 (md2), ..... Last md1, md2, ... are combined
as raid0. That all is done internaly and more flexible. The above is
just so you can visualize the layout. Writes will always go to sdX1
and sd(X+1)2. Reads should always go to sdX1, which is usualy the
faster part on rotating disks.

You need to optimize the raid0 part and, probably way more important,
the alignment of your data access. If everything is aligned nicely
each request should be fully serviced by a single disk given your
small request size. And the seeks should be evenly spread out between
the disks with each disk seeking every 12 reads or twice every 6
writes (or less). Check if you are seeking more than is expected.

Also, on a lower level, make sure your raid does not start on a
partition starting at sector 63 (which is still the default in many
partitioning progs). That easily results in bad alignment causing 4k
chunks to land on 2 sectors. But you need to test that with your
specific drive to see if it really is a problem.

MfG
        Goswin

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
