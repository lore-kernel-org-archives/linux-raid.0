From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Sat, 19 Dec 2009 17:49:01 -0600
Message-ID: <7D.E7.01567.1766D2B4@cdptpa-omtalb.mail.rr.com>
References: <4B2D6447.1070406@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2D6447.1070406@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'John Robinson' <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 19/12/2009 20:19, Leslie Rhorer wrote:
> [...]
> >> The reason why you can't mount even though repair suggests you do
> >> might be because of a bug in xfsprogs/libs not a complete corruption
> >> in the filesystem itself.
> >
> > 	It's possible, I guess, but the diagnostics seem pretty coherent.
> > Running xfs_repair in test mode finds a small but reasonable number of
> > issues.
> 
> Please excuse me if this is a stupid question, but is it possible any of
> the apparent issues could be caused by the block device underneath the
> filesystem having changed size, so the filesystem's in some sense the
> wrong size now?

	I don't know.  It certainly shouldn't.  Xfs certainly supports
growing the file system, and presumably this would be often accomplished by
first growing the underlying device.

