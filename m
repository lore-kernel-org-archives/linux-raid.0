From: Billy Crook <billycrook@gmail.com>
Subject: Re: raid0 not growable?
Date: Wed, 30 Dec 2009 00:26:26 -0600
Message-ID: <a43edf1b0912292226l6327d9ecu7d7f0fb1aca4633e@mail.gmail.com>
References: <73e903670912230552n226e9052q182174cba32f3c54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670912230552n226e9052q182174cba32f3c54@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 23, 2009 at 07:52, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
> Hi,
>
> I'm running a raid0 array over a couple of raid6 arrays. I had planne=
d
> on growing the arrays in time, and now turns out to be the time.
>
> To my chagrin, searches indicate that raid0 isn't growable. Can anyon=
e
> confirm this before I wipe and reconfigure?

Not that this would solve your particular problem, but for the future,
or if you do wipe and reconfigure, I would recommend:

When you don't want your individual raid6 arrays to be any larger
(because you don't want to further increase the probability of
failure), don't use raid0 on top of multiple raid6 arrays.  Use LVM.
Make each raid6 array a PV.  Add them all to one VG.  Then make one
LV, specifying striping.  Remember that lvm extent size is NOT the
size of lvm's striping.

lvcreate -i3 -I4 -l 50%FREE -n lv_bigfast vg_arrays /dev/md3 /dev/md4 /=
dev/md5
will create a logical volume named lv_bigfast using 50% of all free
space in the volume group vg_arrays; split evenly between three
contributing physical volumes md[345] (each say an 8 2TB disk raid6
array), and striped in 4kb slices.  Adjust as you see fit.  Over time,
you can add more md# arrays, and grow the LV and its filesystem while
its in use.  You can even (if you have enough freespace, shrink the
PVs, pop a disk out of each, add some more component disks, and narrow
your disk failure domains (the number of disks in each underlying
raid6 array) on the fly without disrupting service.  It will be far
from instantaneous, but it beats disrupting service.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
