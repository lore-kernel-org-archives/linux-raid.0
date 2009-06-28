From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Adding a smaller drive
Date: Sun, 28 Jun 2009 13:31:06 -0500
Message-ID: <20090628183111280.HTRN20969@cdptpa-omta01.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	I have a few questions.  Some RAID implementations will simply
refuse to create or grow an array if all the targets are not precisely the
same size.  Clearly this is not the case for mdadm.  Not all drives of a
given "size" are actually precisely the same size, however, and I am using
unpartitioned drives for my RAID systems.  What happens if I add a drive
whose apparent physical size is a bit smaller than the device size used to
create the array?  Does the resync force a smaller device size?  What is the
limit for how much smaller a new drive can be than the smallest extant in
the array?  What if I try to replace a drive in the array with one smaller
than the provisioned device size?  This would apparently shrink the array
some.  I take it in such a scenario I should shrink the filesystem on the
array before replacing the drive (scary!)?  How will I know a-priori this
would be the case?

