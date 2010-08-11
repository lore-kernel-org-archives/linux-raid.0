From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: md's fail to assemble correctly consistently at system startup -
	mdadm 3.1.2 and Ubuntu 10.04
Date: Tue, 10 Aug 2010 22:17:19 -0700
Message-ID: <AANLkTikiC+YF8ZtND2ub6mY_9o0zLQT+4jW1zzhA-98x@mail.gmail.com>
References: <AANLkTinQgx1t0eaXuFKLnf+5PBw1AqJpyYfxo-AvZXQf@mail.gmail.com>
	<20100808185806.69085415@notabene>
	<AANLkTi=j5WddChbtjBRCJFc=6XvOmEGL3bZdqJ3NfNeK@mail.gmail.com>
	<20100809210019.3cc064ab@notabene>
	<AANLkTi=_LKK7t1zPfcBwdTaSj6xDcBX9XAWbuN7mnPZD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=_LKK7t1zPfcBwdTaSj6xDcBX9XAWbuN7mnPZD@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 9, 2010 at 4:58 AM, fibreraid@gmail.com <fibreraid@gmail.com> wrote:
> Hi Neil,
>
> I may have spoken a bit too soon. It seems that while the md's are
> coming up successfully, on occasion, hot-spares are not coming up
> associated with their proper md's. As a result, what was a RAID 5 md
> with one hot-spare will on occasion come up as a RAID 5 md with no
> hot-spare.
>
> Any ideas on this one?
>

Is this new behavior only seen with 3.1.3, i.e when it worked with
3.1.2 did the hot spares always arrive correctly?  I suspect this is a
result of the new behavior of -I to not add devices to a running array
without the -R parameter, but you don't want to make this the default
for udev otherwise your arrays will always come up degraded.

We could allow disks to be added to active non-degraded arrays, but
that still has the possibility of letting a stale device take the
place of a fresh hot spare (the whole point of changing the behavior
in the first place).  So as far as I can see we need to query the
other disks in the active array and permit the disk to be re-added to
an active array when it is demonstrably a hot spare (or -R is
specified).

--
Dan
