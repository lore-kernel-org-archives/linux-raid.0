From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.2 new option
Date: Fri, 16 Dec 2005 12:50:29 +1100
Message-ID: <17314.7525.203935.577073@cse.unsw.edu.au>
References: <43A1EAAA.6090802@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert Heinzmann on Thursday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 15, Robert.Heinzmann@gmx.net wrote:
> Hello,
> 
> i just downloaded the mdadm 2.2 version. It seems that there are some 
> new options which are not explained in details. of special interest are 
> 2 options.
> 
> -GROW
> The new grow mode is very very helpfull for us. It would allow us to do 
> resize operations with md devices at last - without the need for LVM.
> The manpage states that the GROW mode requires kernel support to work. 
> There is no note that states, which kernel supports the options. Also 
> with various distributions with patched kernels its not possible to say 
> version X.Y.Z. of the kernel contains the required patches.
> 
> Is there a way to find out via mdadm, if the current kernel supports the 
> GROW mode, prior to performing the GROW ?

No, there isn't.  However if your kernel doesn't support the
operation, it will fail cleanly so there is no risk.

> 
> -bitmap
> 
> As far as I understand this bitmap options, in incorperates write intend 
> logging.
> Is this based on paper by James Bottomley ? Also is there a way to find 
> out via mdadm if the running kernel supports intend logging via
> mdadm ?

Yes, it is comes (indirectly) from James.
No, you cannot query the kernel.

> 
> -There is also an option --write-mostly since 2.0.
> 
> I guess this especially usefull for MD devices with large storage arrays 
> as backend. They have clever caches and read ahead paramaters, that can 
> be non-effective if we change the disk for each read. Does this option 
> require a kernel modification too ?

Yes, this also requires a recent kernel - 2.6.14 I think.
It is intended for mirrored situations where one mirror is over a slow
link (e.g. over the Internet). .

> 
> One last question. Besindes the source code and manpage is there oterh 
> documentation available on how the md works internally ? (update of 
> superblock, handling of device renaming inside the superblock etc.)

No there isn't, though I am seeing more and more requests for this and
am starting to wonder if I should commit some time to writing
something.

NeilBrown
