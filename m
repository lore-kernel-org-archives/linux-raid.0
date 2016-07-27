From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Wed, 27 Jul 2016 14:22:18 +0100
Message-ID: <22424.46474.87462.226497@tree.ty.sabi.co.uk>
References: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
	<22423.44287.974770.114127@tree.ty.sabi.co.uk>
	<5797C5CE.6020300@youngman.org.uk>
	<CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=arvFWy-9_e8L3ngdrYxwGxVNm=zTqoLusvwKmmkUnBfQQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> I can plug all my drives the sata plug are not a problem :-) I
> use around 4.5TB on my current raid 5

That opens up some more options, if it can be cut down to less
than 4TB, which may be possible e.g. by compression (unless most
files are already compressed), for example by doing a full
backup of your existing content as a '.tar.lzo' to one of the
new 4TB drives, which would give you backup, and one from which
after you create a new RAID set, a source to repopulate your
data.

Also, if the data is just 4.5TB, why not go for just a 3x RAID5
with the 3x 4TB drives, which a usable capacity of 8TB? A degree
of redundancy of 1-in-3 is not bad. It would have less IOPS
though.

Another option I did not mention would be to split the 3x 4TB
drives in two, and then create a 3x RAID5 set on one half with a
4TB usable capacity, and a 5x RAID6 set on the other half plus
the 2x 2TB drives, with a 6TB usable capacity.

> at first i thought about using rsync to do my copy

The 'rsync' is good, I use that especially for updates, but
something like this is often better for an initial full copy
because it parallelizes a bit reading and writing:

  tar -C $FROM -c --one -b 512 -f - . \
    | tar -C $TO -x --preserve-p -b 512 -f -

The alternative of a 'dd' block-by-block physical copy of the
existing members onto suitably sized partitions on the new
drives, which would be faster and safer; but a 'rsync'/'tar'
file-by-file logical copy has the advantage of defragmenting the
destination, at the price of much slower and riskier seek-based
reading of the source.

> in-place migration would be a nice and safe operation now i
> don't what to think ? [ ... ]

Most in-place migrations succeed, even if very very slowly.

The problem happens in the rare but not so uncommon cases where
they fail: if you have a full backup it's not a big problem, if
you don't then it gets rather "challenging".
