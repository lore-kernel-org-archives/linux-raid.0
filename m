From: Dieter Stueken <stueken@conterra.de>
Subject: Re: Bad blocks are killing us!
Date: Fri, 19 Nov 2004 19:47:30 +0100
Message-ID: <419E3FC2.6080205@conterra.de>
References: <200411180147.iAI1l5N02116@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411180147.iAI1l5N02116@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy Watkins wrote:
> "but the md-level
> approach might be better.  But I'm not sure I see the point of
> it---unless you have raid 6 with multiple parity blocks, if a disk
> actually has the wrong information recorded on it I don't think you
> can detect which drive is bad, just that one of them is."
>=20
> If there is a parity block that does not match the data, true you do =
not
> know which device has the wrong data.  However, if you do not "correc=
t" the
> parity, when a device fails, it will be constructed differently than =
it was
> before it failed.  This will just cause more corrupt data.  The parit=
y must
> be made consistent with whatever data is on the data blocks to preven=
t this
> corrosion of data.  With RAID6 it should be possible to determine whi=
ch
> block is wrong.  It would be a pain in the @$$, but I think it would =
be
> doable.  I will explain my theory if someone asks.

This is exactly the same conflict, a single drive has with a unreadable=
 sector.
It notices the sector beeing bad, and it can not fulfill any read reque=
st, until
the data is not rewritten or erased. The single drive can not (and shou=
ld never
try to!) silently replace the bad sector by some spare sectors, as it c=
an not
recover the content.

Also the RAID system can not solve this problem automagically, and neve=
r should
do so, as the former content can not be deduced any more. But notice, t=
hat we
have two very different problems to examine: The above problem arises, =
if all
disks of the RAID system claim to read correct data, whereas the parity=
 information
tells us, that one of them must be wrong. As long as we don't have RAID=
6,
to recover single bit errors, the data is LOST and can not be recovered=
=2E
This is very different to the situation, if one of the disks DOES repor=
t
an internal crc-error. In this case your data CAN be recovered reliable=
 from the
parity information, and in most cases even successfully written back to=
 the disk.

But there is also a difference between the problem for RAID compared to=
 the internal
disk: Whereas the disk always reads all CRC data for the sector to veri=
fy its integrity,
the RAID system does not normally check the validity of the parity info=
rmation
by default. (this is, why the idea of data scans actually came up). So,=
 if a scan
discovers a bad parity information, the only action that can (and must!=
) be taken
is, to tag this peace of data to be invalid. And it is very important, =
not only
to log that information somewhere. It is even more important to prevent=
 further readings
of this peace of lost data. Otherwise those definitely invalid data may=
 be read
without any notice, may get written back again and thus turn into valid=
 data,
even though it become garbage.

People often argue for some spare sector management, which would solve =
all problems.
I think this is an illusion. Spare sectors can only be useful if you fa=
il WRITING data,
not when reading data failed or data loss occurred. This is realized al=
ready within
the single disks in a sufficient way (I think). If your disk gives writ=
e errors, you
either have a very old one, without internal spare sector management, o=
r your disk
run out of spare sectors already. Read errors are quite more frequent t=
han write
errors and thus a much more important issue.

Dieter St=FCken.
--=20
Dieter St=FCken, con terra GmbH, M=FCnster
     stueken@conterra.de
     http://www.conterra.de/
     (0)251-7474-501
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
