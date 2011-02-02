From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Tue, 01 Feb 2011 19:08:09 -0500
Message-ID: <4D48A069.8010202@cfl.rr.com>
References: <4CF81A16.2010606@cfl.rr.com>	<20101203123615.6edce071@notabene.brown>	<4CF860EB.7010005@cfl.rr.com>	<20101209094354.4c6aaa93@notabene.brown>	<4D01328D.9050503@cfl.rr.com> <4D46E6D7.2000205@cfl.rr.com>	<20110131170349.GR343@caffeine.csclub.uwaterloo.ca>	<4D470BCF.20508@cfl.rr.com>	<20110131221252.GT343@caffeine.csclub.uwaterloo.ca>	<4D47627A.1080509@cfl.rr.com> <20110201162642.GU343@caffeine.csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201162642.GU343@caffeine.csclub.uwaterloo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Neil Brown <neilb@suse.de>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/01/2011 11:26 AM, Lennart Sorensen wrote:
> If the raid stores the raid info at the end, then the data starts at
> sector 0.  So no space for a bootloader at all.

I know that is how it works with 0.9, but are you sure it is for 1.0? 
If so, then for anything but raid-1 we will just have to try to install 
only to the first device if it has an MBR.

> Certainly makes sense.  Now is 4K enough for a boot loader?  Not sure.

It is enough for the MBR.  The core image will need to go elsewhere, 
hence the proposal to ask mdadm for a suitable location.

> I personally consider soft raid on raw devices so convluted that I
> have never done it.  I would rather have something I know works with my
> bootloader and other tools, than gain that extra 1MB (at most) that not
> having partitions gives.  Also given many PCs won't boot from a drive
> without a partition table, it isn't even an option then.

That is why I like the idea of 1.2 since you could still have a bootable 
MBR when using the whole disk.  Though now that you mention it, I can't 
think of a good reason to use the whole disk instead of a partition either.

