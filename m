From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: RE: device and partition alignment
Date: Sat, 5 Jun 2010 20:19:41 -0400
Message-ID: <000601cb050d$f655c140$e30143c0$@woodlea.com>
References: <000001cb0504$e49c07b0$add41710$@woodlea.com> <15.FE.17309.236EA0C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15.FE.17309.236EA0C4@cdptpa-omtalb.mail.rr.com>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Leslie Rhorer' <lrhorer@satx.rr.com>, 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > Then we come back to the physical disks that go to make up the RAID
> > device.
> > I guess the simplest way (or am I being too simplistic here) would be
> > to use the raw device, which would (should?) guarantee that everything
> > would be aligned? However, I want to be able to use partitions on the
> > disk to create the array, so that doesn't really help.
> 
> 	Why?  I haven't seen anything in your message which suggests they
> are necessary.  If you don't need partitions, then I suggest you don't use
> them.  None of my data arrays have partitions either above or below the
> RAID layer.  The md targets are raw disks and the filesystems are created
> directly on top of the RAID block device.



In the case of the media server, partitions aren't really needed, I'd agree.
However, one of the other projects I have in mind is a storage server with
differing requirements - I'd like to be able to make small partitions on the
disks for fast access (basically short stroke them) as a RAID 10 for
business hour use, and use the large rest of the drives as a RAID 5 array
for backup storage, which would only be used during off hours.

So I'd agree, in some cases using the raw devices makes sense, but in others
it makes sense to partition - and I'd like to have the knowledge for both
situations.


Graham

