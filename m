From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: device and partition alignment
Date: Sat, 5 Jun 2010 19:05:01 -0500
Message-ID: <15.FE.17309.236EA0C4@cdptpa-omtalb.mail.rr.com>
References: <000001cb0504$e49c07b0$add41710$@woodlea.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000001cb0504$e49c07b0$add41710$@woodlea.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Then we come back to the physical disks that go to make up the RAID
> device.
> I guess the simplest way (or am I being too simplistic here) would be to
> use
> the raw device, which would (should?) guarantee that everything would be
> aligned? However, I want to be able to use partitions on the disk to
> create
> the array, so that doesn't really help.

	Why?  I haven't seen anything in your message which suggests they
are necessary.  If you don't need partitions, then I suggest you don't use
them.  None of my data arrays have partitions either above or below the RAID
layer.  The md targets are raw disks and the filesystems are created
directly on top of the RAID block device.

> isn't
> really. Some things you need to need to make some number based on (say)
> the
> type of files on the final file system, where a smaller chunk size would
> make sense, in other cases, a larger chunk size would make sense. But once
> you've made those design decisions, there should be some set of formulae
> you

	Chunk size is another matter.

