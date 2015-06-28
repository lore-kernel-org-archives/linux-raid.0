From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: [Bug 100491] New: Oops under bitmap_start_sync [md_mod] at boot
Date: Sun, 28 Jun 2015 23:53:48 +0300
Message-ID: <20150628205347.GA18403@sli.dy.fi>
References: <12832_1435266173_558C6C7D_12832_48_1_bug-100491-1606@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <12832_1435266173_558C6C7D_12832_48_1_bug-100491-1606@https.bugzilla.kernel.org/>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>, Neil Brown <neilb@suse.de>, bugzilla-daemon@bugzilla.kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 25, 2015 at 09:02:45PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=100491
> 
>             Bug ID: 100491
>            Summary: Oops under bitmap_start_sync [md_mod] at boot
[...]
> Reading all physical valumes.  This may take a while...
> Found volume group "rootvg" using metadata type lvm2
> device-mapper: raid: Device 0 specified for rebuild: Clearing superblock
> md/raid1:mdX: active with 1 out of 2 mirrors
> mdX: invalid bitmap file superblock: bad magic
> md-cluster module not found.
> mdX: Could not setup cluster service (256)
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
> IP: [<ffffffff8159e4a9>] _raw_spin_lock_irq+0x29/0x70
> PGD 0
> Oops: 0002 [#1] PREEMPT SMP
[...]

I'm marking this as a regression in bugzilla, since this seems to
prevent booting on 4.1.0 at least in certain circumstances (namely
those which I have; I wonder if any raid1 recovery works?) while 4.0.6
boots correctly.

I bisected this down to one of four commits. Well, assuming that the
problem was caused by changes in drivers/md; a fair assumption, I
think. The commits are:

$ git bisect view --oneline
f9209a3 bitmap_create returns bitmap pointer
96ae923 Gather on-going resync information of other nodes
54519c5 Lock bitmap while joining the cluster
b97e9257 Use separate bitmaps for each nodes in the cluster

The crash happens whether or not CONFIG_MD_CLUSTER is enabled.

Here's the versions I tested:

git bisect start '--' 'drivers/md'
# bad: [b953c0d234bc72e8489d3bf51a276c5c4ec85345] Linux 4.1
# good: [39a8804455fb23f09157341d3ba7db6d7ae6ee76] Linux 4.0
# bad: [9ffc8f7cb9647b13dfe4d1ad0d5e1427bb8b46d6] md/raid5: don't do chunk aligned read on degraded array.
# bad: [6dc69c9c460b0cf05b5b3f323a8b944a2e52e76d] md: recover_bitmaps() can be static
# bad: [4b26a08af92c0d9c0bce07612b56ff326112321a] Perform resync for cluster node failure
# good: [cf921cc19cf7c1e99f730a2faa02d80817d684a2] Add node recovery callbacks
# skip: [96ae923ab659e37dd5fc1e05ecbf654e2f94bcbe] Gather on-going resync information of other nodes
# bad: [f9209a323547f054c7439a3bf67c45e64a054bdd] bitmap_create returns bitmap pointer
# skip: [54519c5f4b398bcfe599f652b4ef4004d5fa63ff] Lock bitmap while joining the cluster

	Sami
