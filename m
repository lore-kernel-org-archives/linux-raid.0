From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: meta: should i chase this down?
Date: Tue, 06 Dec 2011 20:39:33 -0800
Message-ID: <5973r8xg7n.ln2@goaway.wombat.san-francisco.ca.us>
References: <42n2r8xe3k.ln2@goaway.wombat.san-francisco.ca.us>
 <20111207114726.2f3f3543@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-12-07, NeilBrown <neilb@suse.de> wrote:
>
> The best way I have found to catch kernel messages is using netconsole.
> See Documentation/networking/netconsole.txt

That's exactly what I was looking for!  It looks like it's working
perfectly so far.  It sure beats the Back In My Day (TM) method of
needing a serial console.

> You almost certainly need some disks to make the RAID6 out of.  You could t=
> ry
> loop-back devices over files but the timing is likely to be very different
> and so the chance of reproducing the bug correspondingly small.

I do have some drive bays that I should be able to free up, and I think
that I have some free disks lying around I can use, which I think should
replicate a more real-life scenario.  I can't honestly say that this
will be a high priority for me :), but I do want to try to be helpful if
there really is a bug, or help myself if there's a problem in my
hardware.  It probably can't hurt to make a first pass with some
loopback devices--if it does crash the kernel, great (for debugging,
anyway); if not, I hunt down some real disks.  (Would using multiple
partitions on one or two disks be a reasonable test case, or should I
not bother and stick with real disks?)

Thanks for your help!

--keith


-- 
kkeller@wombat.san-francisco.ca.us


