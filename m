From: Chris Murphy <lists@colorremedies.com>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data loss)
Date: Tue, 17 Feb 2015 12:33:52 -0700
Message-ID: <CAJCQCtQvoB0yPPc=RXPPyJhpaFwH0pQTRCRaR_ycTbzHrD6rLw@mail.gmail.com>
References: <loom.20150214T222329-324@post.gmane.org>
	<20150216142845.0d50207c@notabene.brown>
	<loom.20150216T124230-883@post.gmane.org>
	<54E1EDEA.1030503@turmel.org>
	<loom.20150216T165111-551@post.gmane.org>
	<54E226B5.1080500@turmel.org>
	<loom.20150216T183419-387@post.gmane.org>
	<20150217104906.62d36c62@notabene.brown>
	<loom.20150217T080345-764@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150217T080345-764@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's not just mdadm. It likewise affects Btrfs, ZFS, and LVM.

Also, there's a lack of granularity with linux command timer and SCT
ERC applying only to the entire block device, not partitions. So
there's a problem for mixed use cases. For example, two drives, each
with two partitions. sda1 and sdb1 are raid0, and sda2 and sdb2 are
raid1. What's the proper configuration for SCT ERC and the SCSI
command timer?

*shrug* I don't think the automatic udev configuration idea is fail
safe. It sounds too easy for it to automatically cause a
misconfiguration. And it also doesn't at all solve the problem that
there's next to no error reporting to user space. smartd does, but
it's narrow in scope and entirely defers to the hard drive's
self-assessment. There's all sorts of problems that aren't in the
domain of SMART that get reported in dmesg, but there's no method for
gnome-shell or KDE or any DE or even send an email to a sysadmin, as
an early warning. Instead, all too often it's "WTF XFS just corrupted
itself!" meanwhile the real problem has been happening for a week,
dmesg/journal is full of errors indicating the nature of those
problems, but nothing bothered to inform a human being until the file
system face planted.


Chris Murphy
