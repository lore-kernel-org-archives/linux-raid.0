From: mark delfman <markdelfman@googlemail.com>
Subject: -z not on RAID0 / MPIO hurdle
Date: Wed, 12 Aug 2009 19:44:10 +0100
Message-ID: <66781b10908121144n1f053b57led29391534614b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.... I am hopeful that the group could provide me with some advice
regarding limiting the drive size on a RAID0.  I know and use the =E2=80=
=93z
option for other raid levels, but this seems to have no effect on
RAID0.

I am sure many will ask =E2=80=98why bother=E2=80=99 or =E2=80=98use fd=
isk=E2=80=99 but the problem is:

We need to have some preserved information on each drive =E2=80=93 can =
be only
a few MB at the end of the drive for example
In the past we have simply used Fdisk to partition, save our data on
Sdx2 and used Mdadm on Sdx1  (which works fine)
But we are looking to move to dual channel SAS drives and use DM MPIO

DM MPIO works fine also, but not on the partitions, only the whole
drive.  So when we MDadm DMx it overwrites the SdX2 partition etc.

The answer was that we used the =E2=80=93z and limited the drive size a=
nd
simply used DD to write our data to the end LBA=E2=80=99s....

But on RAID0 the =E2=80=93z does not seem to function, so I cant think =
of a
way around this =EF=81=8C  (other than changing the LBA range in the dr=
ive and
this is restricted I think)


Does anyone have any ideas?  I appreciate any help
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
