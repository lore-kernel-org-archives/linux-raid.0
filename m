From: Pierre =?utf-8?q?Vign=C3=A9ras?= <pierre@vigneras.name>
Subject: Re: mdadm: failed devices become spares! -> Solved !
Date: Fri, 21 May 2010 23:27:49 +0200
Message-ID: <201005212327.49734.pierre@vigneras.name>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com> <20100518113016.1981a08c@notabene.brown> <20100518120637.24d875c9@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100518120637.24d875c9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for the delay of my reply...

This small mail to let you know that my RAID array is currently recover=
ing=20
thanks to the valuable inputs of this mailing list users. You are great=
!

=46or the curious, what I did is the following:

# ##### Do not forget the '--assume-clean' as I almost did! ;-(
# mdadm -C /dev/md2 -l 10 -n 4 -c 64 -e 0.90 --assume-clean /dev/sdd1 m=
issing=20
/dev/sdc1 missing              =20
# vgchange -a y                                                        =
                                      =20
# xfs_repair -n -t 1 -v /dev/my-vg/my-lv
# mount -o ro /dev/my-vg/my-lv /mnt/tmp
# find /mnt/tmp
# du -ks /mnt/tmp/
# umount /mnt/tmp
# #### Required: XFS asked the log to get replayed
# mount /dev/my-vg/my-lv /mnt/tmp/
# umount /mnt/tmp
# xfs_repair  -t 1 -v /dev/my-vg/my-lv
# mdadm --manage /dev/md2 --add /dev/sde1
# mdadm --manage /dev/md2 --add /dev/sdf1

The array is currently at 25 % of the recovery process. A bit too soon =
to say=20
that everything is fine... By the way, I am quite sure now that my USB=20
controllers (or the use driver or whatever in the chain except all disk=
s) are=20
buggy: all the other RAIDs of my setup are gone!

I will try to recover them using the same kind of process, to backup al=
l data.=20
Do you think that using BBR (since each time, the burden started due to=
 a=20
sector (write?) error), the problem will be "solved" (or at least postp=
oned=20
until BBR itself does not have enough free sectors)?

Anyway, again, thanks a lot to all of you.=20
Open Source rocks! ;-)
--=20
Pierre Vign=C3=A9ras
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
