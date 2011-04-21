From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Direct disk access on IBM Server
Date: Thu, 21 Apr 2011 01:24:48 -0500
Message-ID: <4DAFCDB0.9070609@hardwarefreak.com>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org> <iomj0a$e5m$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iomj0a$e5m$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown put forth on 4/20/2011 7:21 AM:

> It's true that boot loaders and software raid can be an awkward
> combination.
...
> Yes, it's a few extra steps.

More than a few. :)  With an LSI RAID card, I simply create a drive
count X RAID5/6/10 array, set to initialize in the background, reboot
the machine with my Linux install disk, create my partitions, install
the OS ... done.  And I never have to worry about the bootloader
configuration.

> Okay, that's good to know.  LSI raid controllers are not hard to get, so

And they're the best cards overall, by far, which is why all the tier 1s
OEM them, including IBM, Dell, HP, etc.

> I am not afraid of being able to find a replacement.  What I was worried
> about is how much setup information is stored on the disks, and how much
> is stored in the card itself.

This information is duplicated in the card NVRAM/FLASH and on all the
drives--been this way with most RAID cards for well over a decade.
Mylex and AMI both started doing this in the mid/late '90s.  Both are
now divisions of LSI, both being acquired in the early 2000s.  FYI the
LSI "MegaRAID" brand was that of AMI's motherboard and RAID card products.

> Yes, the raid card I have can do RAID10.  But it can't do Linux md style
> raid10,far - I haven't heard of hardware raid cards that support this.

What difference does this make?  You already stated you're not concerned
with performance.  The mdraid far layout isn't going to give you any
noticeable gain with real world use anyway, only benchmarks, if that.

Some advice:  determine how much disk space you need out of what you
have.  If it's less than the capacity of two of your 4 drives, use
hardware RAID10 and don't look back.  If you need the capacity of 3,
then use hardware RAID 5.  You've got a nice hardware RAID card, so use it.

> For most uses, raid10,far is significantly faster than standard raid10

Again, what difference does this make?  You already stated performance
isn't a requirement.  You're simply vacillating out loud at this point.

> It is certainly possible to do MD raid on top of HW raid.  As an
> example, it would be possible to put a raid1 mirror on top of a hardware
> raid, and mirror it with a big external drive for extra safety during
> risky operations (such as drive rebuilds on the main array).  And if I
> had lots of disks and wanted more redundancy, then it would be possible
> to use the hardware raid to make a set of raid1 pairs, and use md raid5
> on top of them (I don't have enough disks for that).

With 4 drives, you could create two hardware RAID 0 arrays and mirror
the resulting devices with mdraid, or vice versa.  And you'd gain
nothing but unnecessary complexity.

What is your goal David?  To vacillate, mentally masturbate this for
weeks with no payoff?  Or build the array and use it?

> It is not possible to put an MD raid /under/ the HW raid.  I started
> another thread recently ("Growing layered raids") with an example of
> putting a raid 5 on top of a set of single-disk raid1 "mirrors" to allow
> for safer expansion.

I think the above answers my question.  As you appear averse to using a
good hardware RAID card as intended, I'll send you my shipping address
and take this problem off your hands.  Then all you have to vacillate
about is what mdraid level to use with your now mobo connected drives.

-- 
Stan
