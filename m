Received: from esaurito.net (coppa.esaurito.net [116.203.102.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A63E25393B
	for <linux-raid@vger.kernel.org>; Fri, 21 Nov 2025 11:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.102.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763723412; cv=none; b=e0yagNo4L6mKfQUuNjCjeXIMZtTkHsASmTS4yfmA1Ecsfn5PSx7uANBjzD3a7kAB3JgE0jVdSqOyvDBDJzF1RAI0uQacvtSz/MqAAhH2E0BOAf79Kz6McfuoxPA0vvp1FA78cM1Ui1dJ15N9+DmO4oZedEh9zlyVbi4cN2slsf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763723412; c=relaxed/simple;
	bh=44NuNhSbVzMYnHMmsrN2h5PC7wj33Hj7Fh7mcDHDUzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDG5RbfyB7bDM+6aWYrl+KxDeSI4/CbvzTiapX9UZW+iMncaYJGcPy3KrvZTkUFglIgWObtRDS/xZ0hqPjj7/ewgtuXwXY8Xi0tnsQUBRXcjYIert3kZHVZZQG+OwuRSLUELIXJJH5u9wt17WUmxq4UQbbdhfRGFl8ig5qnhRtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; arc=none smtp.client-ip=116.203.102.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Received: by esaurito.net (Postfix, from userid 1000)
	id 1C20640614; Fri, 21 Nov 2025 11:01:18 +0000 (UTC)
Date: Fri, 21 Nov 2025 11:01:18 +0000
From: Filippo Giunchedi <filippo@debian.org>
To: linux-raid@vger.kernel.org
Cc: 1121006@bugs.debian.org, Salvatore Bonaccorso <carnil@debian.org>
Subject: raid10 and component devices optimal_io_size 0xFFF000 results in
 array optimal_io_size 0xFFF00000
Message-ID: <aSBGfk4C0gQPca0P@esaurito.net>
References: <aR3KLd0kR43NeuwT@esaurito.net>
 <aR33hJMYzJOXUhgp@eldamar.lan>
 <aR8pDIXtWf+kPfO9@esaurito.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR8pDIXtWf+kPfO9@esaurito.net>

Hello linux-raid,
I'm seeking assistance with the following bug: recent versions of mpt3sas
started announcing drive's optimal_io_size of 0xFFF000 and when said drives are
part of a mdraid raid10 the array's optimal_io_size results in 0xFFF000.

When an LVM PV is created on the array its metadata area by default is aligned
with its optimal_io_size, resulting in an abnormally-large size of ~4GB. During
GRUB's LVM detection an allocation is made based on the metadata area size
which results in an unbootable system. This problem shows up only for
newly-created PVs and thus systems with existing PVs are not affected in my
testing.

I was able to reproduce the problem on qemu using scsi-hd devices as shown
below and on https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1121006. The bug
is present both on Debian' stable kernel and Linux 6.18, though I haven't yet
determined when the change was introduced in mpt3sas.

I'm wondering where the problem is in this case and what could be done to fix
it?

thank you,
Filippo

On Thu, Nov 20, 2025 at 02:43:24PM +0000, Filippo Giunchedi wrote:
> Hello Salvatore,
> Thank you for the quick reply.
> 
> On Wed, Nov 19, 2025 at 05:59:48PM +0100, Salvatore Bonaccorso wrote:
> [...]
> > >         Capabilities: [348] Vendor Specific Information: ID=0001 Rev=1 Len=038 <?>
> > >         Capabilities: [380] Data Link Feature <?>
> > >         Kernel driver in use: mpt3sas
> > 
> > This sounds like quite an intersting finding but probably hard to
> > reproduce without the hardware if it comes to be specific to the
> > controller type and driver.
> 
> That's a great point re: reproducibility, and it got me curious on something I
> hadn't thought of testing. Namely if there's another angle to this: does any
> block device with the same block I/O hints exhibit the same problem? The answer is
> actually "yes".
> 
> I used qemu 'scsi-hd' device to set the same values to be able to test locally.
> On an already-installed VM I added the following to present four new devices:
> 
> -device virtio-scsi-pci,id=scsi0 
> 
> -drive file=./workdir/disks/disk3.qcow2,format=qcow2,if=none,id=drive3
> -device scsi-hd,bus=scsi0.0,drive=drive3,physical_block_size=4096,logical_block_size=512,min_io_size=4096,opt_io_size=16773120
> 
> -drive file=./workdir/disks/disk4.qcow2,format=qcow2,if=none,id=drive4
> -device scsi-hd,bus=scsi0.0,drive=drive4,physical_block_size=4096,logical_block_size=512,min_io_size=4096,opt_io_size=16773120
> 
> -drive file=./workdir/disks/disk5.qcow2,format=qcow2,if=none,id=drive5
> -device scsi-hd,bus=scsi0.0,drive=drive5,physical_block_size=4096,logical_block_size=512,min_io_size=4096,opt_io_size=16773120
> 
> -drive file=./workdir/disks/disk6.qcow2,format=qcow2,if=none,id=drive6
> -device scsi-hd,bus=scsi0.0,drive=drive6,physical_block_size=4096,logical_block_size=512,min_io_size=4096,opt_io_size=16773120
> 
> I used 10G files with 'qemu-img create -f qcow2 <file> 10G' though size doesn't
> affect anything in my testing.
> 
> Then in the VM:
> 
> # cat /sys/block/sd[cdef]/queue/optimal_io_size 
> 16773120
> 16773120
> 16773120
> 16773120
> # mdadm --create /dev/md1 --level 10 --bitmap none --raid-devices 4 /dev/sdc /dev/sdd /dev/sde /dev/sdf
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md1 started.
> # cat /sys/block/md1/queue/optimal_io_size 
> 4293918720
> 
> I was able to reproduce the problem with src:linux 6.18~rc6-1~exp1 as well as 6.12.57-1.
> 
> Since it is easy to test this way I tried with a few different opt_io_size values and
> was able to reproduce only with 16773120 (i.e. 0xFFF000).
> 
> > I would like to ask: Do you have the possibility to make an OS
> > instalaltion such that you can freely experiment with various kernels
> > and then under them assemble the arrays? If so that would be great
> > that you could start bisecting the changes to find where find changes.
> > 
> > I.e. install the OS independtly on the controller, find by bisecting
> > Debian versions manually the kernels between bookworm and trixie
> > (6.1.y -> 6.12.y to narrow down the upsream range).
> 
> Yes I'm able to perform testing on this host, in fact I worked around the
> problem for now by disabling LVM's md alignment auto detection and thus we have
> an installed system.
> For reference that's "devices { data_alignment_detection = 0 }" in lvm's
> config.
> 
> > Then bisect the ustream changes to find the offending commits. Let me
> > know if you need more specific instructions on the idea. 
> 
> Having pointers on how the recommended way to build Debian kernels would be of
> great help, thank you!
> 
> > Additionally it would be interesting to know if the issue persist in
> > 6.17.8 or even 6.18~rc6-1~exp1 to be able to clearly indicate upstream
> > that the issue persist in upper kernels. 
> > 
> > Idealy actually this goes asap to upstream once we are more confident
> > ont the subsystem to where to report the issue. If we are reasonably
> > confident it it mpt3sas specific already then I would say to go
> > already to:
> 
> Given the qemu-based reproducer above, maybe this issue is actually two bugs:
> raid10 as per above, and mpt3sas presenting 0xFFF000 as optimal_io_size. While
> the latter might be suspicious maybe it is not wrong per-se though?
> 
> best,
> Filippo
