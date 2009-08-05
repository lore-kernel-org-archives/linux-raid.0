From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [md PATCH 8/8] md: Use revalidate_disk to effect changes in size
 of	device.
Date: Wed, 05 Aug 2009 15:07:03 -0700
Message-ID: <4A7A0287.5010505@zytor.com>
References: <20090802215444.4198.83094.stgit@notabene.brown> <20090802215818.4198.77041.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090802215818.4198.77041.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/02/2009 02:58 PM, NeilBrown wrote:
> As revalidate_disk calls check_disk_size_change, it will cause
> any capacity change of a gendisk to be propagated to the blockdev
> inode.  So use that instead of mucking about with locks and
> i_size_write.
> 
> Also add a call to revalidate_disk in do_md_run and a few other places
> where the gendisk capacity is changed.
> 

This patch causes my Fedora 11 system with all filesystems on RAID-1 to
not boot (it hangs in early userspace, Ctrl-Alt-Del reboots the system.)

	-hpa

