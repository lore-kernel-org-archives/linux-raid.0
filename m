From: Chris Murphy <lists@colorremedies.com>
Subject: Re: raid1 issue after disk failure: both disks of the array are still active
Date: Fri, 14 Sep 2012 12:04:56 -0600
Message-ID: <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5052E096.5040509@linuxsystems.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 14, 2012, at 1:45 AM, Niccol=F2 Belli wrote:

> I also would like to know if the raid1 will *surely* use data from th=
e other disk to write on the broken sector after a CHECK.

Not according to documentation. In normal operation, and for a repair, =
what you describe is correct. But not for check.

> I mean, i did nothing even after a read error on md0 with a "failed c=
ommand: READ DMA" in dmesg (possibly because after a few reads it succe=
eded reading?).

Possibly. Possibly the disk firmware finally was able to relocate that =
sector's data. Possibly its ECC thinks it has reconstructed the data on=
 that sector, but in fact the data is corrupt.

> I read that when raid1 is in doubt there is a 50%-50% chance it uses =
data from the good disk, wouldn't be better to fail the broken disk and=
 then re-add it to the array?

I don't know what this means.

But I think there's a misunderstanding about disk behavior. A disk's re=
liability is not always a binary condition. Most often it's a continuum=
, because sector problems are masked by disk's ECC, and they go entirel=
y unreported to the kernel, and thus md. This includes the case when th=
e disk ECC detects an error, and thinks it has corrected it, but actual=
ly returns bogus (corrupt) data rather than a read error; as well as wh=
en disk ECC does not detect an error at all, but the data is in fact co=
rrupt.

The md driver has no practical choice but to trust the data the disk re=
turns, absent an error. So I'm confused by what you mean by "when raid1=
 is in doubt" and what you mean by this "50/50 chance" part.

When the disk ECC detects an error, and fails to correct it, only then =
will it report a read error to the kernel, and then md will get that da=
ta elsewhere. There is no good reason for md to mark a 99.99% correctly=
 performing disk as faulty. If it did this, you've unnecessarily abando=
ned those 99.99% useful sectors, and in so doing have significantly red=
uced redundancy.

There's a reason why there are check and repair functions, rather than =
wholesale discarding an otherwise valuable disk with a handful of bad s=
ectors (or even one), and the ensuing loss of redundancy. Check is read=
 only so it will be faster than repair, is a good reason to use check f=
requently and repair less frequently unless check warrants it. And ther=
e's good reason to include some smartd periodic testing as well since t=
here are parts of the disk that md check/repair can't test *and* becaus=
e the disk ECC masks problems, whereas SMART should report them.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
