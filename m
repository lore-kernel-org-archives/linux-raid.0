From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: multi-hosting support for carrier grade Linux
Date: Tue, 05 Apr 2005 17:50:23 -0400
Message-ID: <4253081F.6000901@steeleye.com>
References: <20050405204155.GA32724@blade.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050405204155.GA32724@blade.az.mvista.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Jiang <djiang@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dave Jiang wrote:
> I'm attempting to implement multihost support of the MD for environments
> such as carrier grade Linux. Multihost support allows the RAID array to
> be claimed by a particular host via a unique ID (unique SCSI host ID,
> FibreChannel WWN, or geographical address of a chassis blade. That way
> another host that can access the disks do not claim the same disks that
> are used by the RAID array. 

Why not just use SCSI reservations?

> I would like to store a 64bit unique ID on the
> superblock of the device. The least intrusive way IMHO to do this is
> implementing the feature via the management app such as mdadm in
> userland. However, it seems that after I instruct the kernel to create the MD array via mdadm, the kernel starts out with a blank superblock and clobbers the

If you write a valid superblock to the disk and then assemble the array, 
the superblock doesn't get clobbered.

> data I have stored on the superblock via mdadm. Would it be acceptable
> to modify the kernel such that the unique ID info is preserved during
> the creation of the superblock by the kernel? Example patch follows:

As for adding additional fields to the various superblock formats, you'd 
have to ask Neil if he's open to that.

--
Paul
