From: David Brown <david@westcontrol.com>
Subject: Re: how to recover filesystem after clobbering array?
Date: Tue, 19 Jul 2011 12:17:25 +0200
Message-ID: <j03lp4$h72$1@dough.gmane.org>
References: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/07/2011 11:43, Vasco N=E9voa wrote:
>
> Hello people.
>
> I've messed up good, and now I need you nice folks to help me recover
> 500GB of irreplaceable home video, the full 7 years of my family trov=
e. :(
>
> I mistakenly used mdadm to *create* an array instead of *starting* th=
e
> array (big Duh!). Now the array has no partition table. I shudder to
> think I may have clobbered not only the array but also the file syste=
m.
> I hardly slept last night. Acceptance is a process. :/
>
> I've learned my lesson there, no more fiddling with "--assume-clean"
> (which was a stupid idea in the first place), but the issue remains: =
how
> do I get to the file system that I know is still there? The array is =
up
> but obviously it was never mounted.
>
> Can I just recreate the partition table and it works?.... or do I hav=
e
> to use some complex form of forensics to recover the data?
>
> Thank you very much,
> Vasco.
>

The first thing you should do is write out "RAID is not a backup=20
solution" 100 times!

Then write down all the information you know - exactly how was the arra=
y=20
built up, how were the disks partitioned, what filesystems, etc.  And=20
what was the exact command you used to mess up the array, and how far=20
did you let it go with resynchronisation, etc.  Make good notes here=20
before you forget.

The next step is to get a couple spare disks that are bigger than your=20
original disks (get 2 TB disks - they cost almost the same as anything=20
smaller).  Make a direct copy of the entire original disks to a file on=
=20
the new disks with something like:

	dd if=3D/dev/sda of=3D/mnt/backup/disk1.img bs=3D1M

Once you have got image files for each of your disks, make copies of=20
these image files to another spare disk.  Keep careful notes of exactly=
=20
what you have done here, and which files are which.  And put your=20
original disks, carefully labelled, on a shelf somewhere.

Now you are in a position to attempt data recovery on your copied files=
=2E=20
  If you do something wrong, you can simply re-copy the image files and=
=20
try again.  You still have absolutely no guarantees that you'll get=20
anything back - but at least you can be sure you are not going to make=20
anything worse.

If you have started re-syncing the two disks as a RAID1 pair, there is =
a=20
good chance that one of the disks contains the original data and=20
filesystem, except where it was overwritten by the new metadata for the=
=20
newly created array.

Then you sit back and hope that someone on this list can give you ideas=
=20
about getting the data back from the image file(s).


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
