From: "David Lethe" <david@santools.com>
Subject: RE: Mapping physical disk block to logical block to selectively repair w/o forcing rescan
Date: Tue, 15 Apr 2008 15:47:05 -0500
Message-ID: <A49AB75A717185448F69082E969E536B03C2647E@34093-EVS1C2.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have some code that does some background media scanning that results =
in a list of physical disks and block numbers that are known bad. I wan=
t to repair the logical (md) block(s) that they correspond to (assuming=
 not RAID0, of course) without a draconian full repair/rescan.=A0 As su=
ch, I need a physical to logical mapping technique.=A0 It doesn't appea=
r that there is a built-in mechanism in mdadm or by echoing a command t=
o the /proc/mdstat, or anything else to force the md subsystem to repai=
r the (parity protected) logical block associated with the physical dis=
k and block that is known bad.=A0=20

(raid5extend.c has a phys2log function that seems to take everything in=
to consideration, and RAID1 is a non-issue,=A0 but as long as I am goin=
g to do this, then might as well cover all the bases and make sure it i=
s done right)=20

Has anybody written a script or something, or is there a technique I ha=
ve missed that will provide block-level mapping?=A0 I don't want to muc=
k with modifying the md driver ... a shell script would be fine as this=
 would be a rare occurrence, and since the disk will take billions of c=
lock cycles to remap a bad sector, then an inefficient mapping script w=
ill hardly be noticeable. =A0=A0

Also, assuming I have to write such a script and now know that block X =
on /dev/mdY needs to be repaired, then is there any risk of data corrup=
tion if I simply issue a read =A0dd if=3D/dev/md$Y of=3D/dev/null count=
=3D1 skip=3D$X to force the md driver to repair the stripe?=20
(Actually, count should be increased large enough to force a non-cached=
 read, and I think block number might need to be examined to make sure =
that it is not associated with a block that contains parity information=
, otherwise, the md engine might not detect the problem and force parit=
y rebuild).

Any advice, comments, code will be appreciated. =A0

David @ santools ^ com
=A0=A0

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
