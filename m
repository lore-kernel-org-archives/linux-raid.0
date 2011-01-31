From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 14:07:05 -0600
Message-ID: <4D471669.3040303@hardwarefreak.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mathias Bur=E9n put forth on 1/31/2011 3:41 AM:

> How would one go about expanding a 4 HDD RAID10 into a 6 HDD RAID10?
> Is it "just" a matter of creating a new RAID1 array of the 2 new HDDs=
,
> then adding them to the RAID0, then expanding whatever is on that
> (lvm, xfs, ext4)?

The best way to do this "down the road" expansion is to simply create a=
nother 4
drive mdraid 10 array and concatenate it to the first with LVM.  My gue=
ss is
that you're more concerned with usable space than IOPs, so you should p=
robably
start with a 4 drive RAID5.  Down the road, you could add a 3 drive mdr=
aid 5 and
concatenate that with the first array using LVM.  This will avoid all k=
inds of
potentially messy, possibly earth shattering mdadm conversions.  Runnin=
g such
conversions on live arrays without a reliable backup/restore capability=
 is just
asking for trouble.  Using concatenation leaves your old and new md arr=
ays
totally intact.

http://linux.about.com/od/commands/l/blcmdl8_lvm.htm

> Are there any design tips, or caveats? For example, how many disks
> would you use at most, in a RAID10 setup?

As many as you want, or that your hardware can support.  The largest RA=
ID 10
array I've setup was 40 drives.  That was an FC SAN controller though, =
not mdraid.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
