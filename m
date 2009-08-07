From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Fri, 7 Aug 2009 06:53:03 +0300
Message-ID: <20090807035303.GA31754@musti.tarvainen.info>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop> <4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop> <4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop> <4A7B708F.4050406@uga.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A7B708F.4050406@uga.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 06, 2009 at 08:08:47PM -0400, Harold Pritchett (harold@uga.edu) wrote:

> Mirrored Linux Mini How-to

A few quick observations:

> Install linux on two identical disk drives in such a way that the failure
> of either of the drives will allow the system to be recovered without any
> loss of data
>
> Both of the drives are partitioned exactly the same:
>      1.  3 primary partitions
>      2.  Partition 1 - size - 1GB format as Linux Raid (fd)
>      3.  Partition 2 - size = real memory size, format as linux swap (82)
>      4.  Partition 3 = size = remainder of disk, format as linux raid (fd)

If I read correctly, you are not only leaving swap out of lvm,
you are not mirroring it at all - which would make the system
crash if the swap disk breaks.
Putting swap on lvm would also allow growing it easily as needed.

Another point is that sometimes it is useful to have multiple
partitions separately mirrored and then combined with lvm:
it allows things like changing the raid configuration from
two-disk raid1 to three-disk raid5 without moving data
via backup and yet avoiding windows of vulnerability
to single-disk failure during the transition.
(Perhaps not common enough to be worth mentioning here,
but I've found it useful.)

> Define a raid 1 mirror named fd0 using the first partition on both drives
> Define a raid 1 mirror named fd1 using the third partition of both drives

Why "fd"? Sounds like floppy disks to me... why not md1 &c?
(Please enlighten me if some raid tool normally uses fd.)

> I'm from the old school.  I believe in lots of partitions.

So do I (indeed I'd add /var/tmp as a separate partition to your
list), but it's independent of mirroring and not worth much
space in a mirroring how-to (let alone mini how-to).

Anyway, your method in all sounds rather too complicated (modern
installers make mirroring during normal installation a breeze), and
although doing it "the hard way" can be useful for learning purposes,
I'd rather write a how-to using easier methods, possibly adding
instructions for other tasks like how to handle broken disks, how to
replace disks with bigger ones without reinstallation, how to add more
disks, how to change raid configuration, &c.

-- 
Tapani Tarvainen
