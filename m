From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Mon, 31 Jan 2011 14:21:51 -0500
Message-ID: <4D470BCF.20508@cfl.rr.com>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>	<4CF55680.5010703@cfl.rr.com>	<20101201092508.7023f974@notabene.brown>	<4CF81A16.2010606@cfl.rr.com>	<20101203123615.6edce071@notabene.brown>	<4CF860EB.7010005@cfl.rr.com>	<20101209094354.4c6aaa93@notabene.brown>	<4D01328D.9050503@cfl.rr.com> <4D46E6D7.2000205@cfl.rr.com> <20110131170349.GR343@caffeine.csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131170349.GR343@caffeine.csclub.uwaterloo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, John Sheu <john.sheu@gmail.com>
List-Id: linux-raid.ids

On 1/31/2011 12:03 PM, Lennart Sorensen wrote:
> If you do software md raid on whole disks, I am not even sure if the
> BIOS could boot from that, since there won't be a partition table, no
> partition marked bootable (which some BIOSs requrie), sector 0 may not
> even contain boot code.  Not sure there is anyway whole device software
> raid makes sense for a bootable drive at all.  It makes sense for data
> drives perhaps.  I just don't see this as a candidate for booting at all.

That is why I asked what the partition table should look like.  When
grub is installed there will be one ( and boot code ), the question is
whether it should be empty, or have a protective partition that claims
the entire disk, like EFI does.

Normally with format 0.9, the raid array starts on sector 0, so the same
MBR appears both at the start of the first physical disk, and at the
start of the array.  This is not possible with 1.1 or 1.2, so where do
they start the array?  I must be at some point further away from sector
0, leaving room for a protective MBR on the component disks that would
be entirely separate from any MBR inside the array.  This leaves room
for grub to be installed on each component disk, rather than only the
first.  It also means that it is incompatible with formats 0.9, 1.1, and
possibly 1.0, depending on whether it includes the first sector in the
array like 0.9 does.

