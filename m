From: Dan Russell <dpr@aol.com>
Subject: Import/recover RAID6 created with SAS2108?
Date: Sun, 6 Mar 2016 16:37:42 -0500
Message-ID: <2832CD22-EADC-4BC6-A250-FE8919A92E0A@aol.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID6 array which was created on a Supermicro card built aroun=
d the LSI 2108.  Two drives failed, I replaced one and started a rebuil=
d, then two more failed, making my array go offline.

It looks like the failure was due to a cabling or backplane problem, an=
d I suspect the data on the drives is good.  However, the Supermicro ca=
rd is unable to read the foreign configs (it thinks there are 3 foreign=
 configs, none of which are importable into a working array).

I would like to attempt recovery per the Wiki=E2=80=99s instructions (o=
verlay files, force assembly, etc); can md read a RAID6 created by the =
2108, or would I be wasting my time?

I have moved the drives from the hardware RAID card to a non-RAID SAS c=
ard and can see all drives.  However, mdadm -E on these drives seems to=
 show the RAID controller=E2=80=99s field of vision (how many defined a=
rrays, total number of physical disks in the system), not any insight i=
nto this drive=E2=80=99s role as a member of an array.  I can paste or =
gist the output of madam -E (304 lines) if it would help.

Thanks in advance-
 Dan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
