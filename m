From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid 6 - TLER/CCTL/ERC
Date: Wed, 06 Oct 2010 21:24:41 +0100
Message-ID: <4CACDB09.20808@anonymous.org.uk>
References: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Zieba <pzieba@networkmayhem.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/10/2010 06:51, Peter Zieba wrote:
> Hey all,
>
> I have a question regarding Linux raid and degraded arrays.
>
> My configuration involves:
>   - 8x Samsung HD103UJ 1TB drives (terrible consumer-grade)

I have some of these drives too. I wouldn't go so far as to call them 
terrible, though 2 out of 3 did manage to get to a couple of pending 
sectors, which went away when I ran badblocks and haven't reappeared.

>   - AOC-USAS-L8i Controller
>   - CentOS 5.5 2.6.18-194.11.1.el5xen (64-bit)
>   - Each drive has one maximum-sized partition.
>   - 8-drives are configured in a raid 6.
>
> My understanding is that with a raid 6, if a disk cannot return a given sector, it should still be possible to get what should have been returned from the first disk, from two other disks. My understanding is also that if this is successful, this should be written back to the disk that originally failed to read the given sector. I'm assuming that's what a message such as this indicates:
> Sep 17 04:01:12 doorstop kernel: raid5:md0: read error corrected (8 sectors at 1647989048 on sde1)
>
> I was hoping to confirm my suspicion on the meaning of that message.

Yup.

> On occasion, I'll also see this:
> Oct  1 01:50:53 doorstop kernel: raid5:md0: read error not correctable (sector 1647369400 on sdh1).
>
> This seems to involved the drive being kicked from the array, even though the drive is still readable for the most part (save for a few sectors).

The above indicates that a write failed. The drive should probably be 
replaced, though if you're seeing a lot of these I'd start suspecting 
cabling, drive chassis and/or SATA controller problems.

Hmm, is yours the SATA controller that doesn't like SMART commands? Or 
at least didn't in older kernels? Do you run smartd? Try without it for 
a bit... If that helps, look on Red Hat bugzilla and perhaps post a bug 
report.

> What exactly is the criteria for a disk being kicked out of an array?
>
> Furthermore, if an 8-disk raid 6 is running on the bare-minimum 6-disks, why on earth would it kick any more disks out? At this point, doesn't it makes sense to simply return an error to whatever tried to read from that part of the array instead of killing the array?

Because RAID isn't supposed to return bad data while bare drives are.

[...]
> Finally, why do the kernel messages that all say "raid5:" when it is clearly a raid 6?:

RAIDs 4, 5 and 6 are handled by the raid5 kernel module. Again I think 
the message has been changed in more recent kernels.

[...]
> Finally, I should mention that I have tried the smartctl erc commands:
> http://www.csc.liv.ac.uk/~greg/projects/erc/
>
> I could not pass them through the controller I was using, but was able to connect the drives to the controller on the motherboard, set the erc values, and still have drives dropping out.

Those settings don't stick across power cycles and presumably you 
powered the drives down to change which controller they were connected 
to, so your setting will have been lost.

Hope this helps.

Cheers,

John.

