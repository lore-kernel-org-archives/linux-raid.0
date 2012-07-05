From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: md device is read only mode
Date: Thu, 5 Jul 2012 19:27:48 +0200
Message-ID: <20120705172748.GA6464@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

following the comment of Neil about the fact that
an md device, in r/o mode, will BUG() in case of
write attempt, I would like to ask for some more
information on the topic.

The problem is the following, mounting a filesystem
in r/o does not, correctly, prevent writes to the
underlying device.

Now, assuming a filesystem is mounted r/w over an
md device, being r/w too, it is pretty clear that
switching the md device to r/o will create problems.

What if the md device is started in r/o mode and
than, later, the filesystem is mounted *without*
specifying r/o mode?

The filesystem might try to write to the device,
but it will not work, of course.
Does this will cause a BUG() in md?

Because using a r/o memory card, there are no
problems, the mount recognize the device is r/o
and it sets the filesystems r/o too.
I do not know if it anyway tries to write to the
r/o device, ignoring the errors reported.

I would say that, if md BUG() in any case, it
could be a bug... :-)

Any comments?

Thanks,

bye,

-- 

piergiorgio
