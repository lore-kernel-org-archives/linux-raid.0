From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Sun, 04 Aug 2013 08:09:48 -0500
Message-ID: <51FE529C.6000502@hardwarefreak.com>
References: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: P Orrifolius <porrifolius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/4/2013 12:49 AM, P Orrifolius wrote:

> I have an 8 device RAID6.  There are 4 drives on each of two
> controllers and it looks like one of the controllers failed
> temporarily.  

Are you certain the fault was caused by HBA?  Hardware doesn't tend to
fail temporarily.  It does often fail intermittently, before complete
failure.  If you're certain it's the HBA you should replace it before
attempting to bring the array back up.

Do you have 2 SFF8087 cables connected to two backplanes, or do you have
8 discrete SATA cables connected directly to the 8 drives?  WRT the set
of 4 drives that dropped, do these four share a common power cable to
the PSU that is not shared by the other 4 drives?  The point of these
questions is to make sure you know the source of the problem before
proceeding.  It could be the HBA, but it could also be a
power/cable/connection problem, a data/cable/connection problem, or a
failed backplane.  Cheap backplanes, i.e. cheap hotswap drive cages
often cause such intermittent problems as you've described here.

> The system has been rebooted and all the individual
> drives are available again but the array has not auto-assembled,
> presumably because the Events count is different... 92806 on 4 drives,
> 92820 on the other 4.
>
> And of course the sick feeling in my stomach tells me that I haven't
> got recent backups of all the data on there.

Given the nature of the failure you shouldn't have lost or had corrupted
but a single stripe or maybe a few stripes.  Lets hope this did not
include a bunch of XFS directory inodes.

> What is the best/safest way to try and get the array up and working
> again?  Should I just work through
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID

Again, get the hardware straightened out first or you'll continue to
have problems.

Once that's accomplished, skip to the "Force assembly" section in the
guide you referenced.  You can ignore the preceding $OVERLAYS and disk
copying steps because you know the problem wasn't/isn't the disks.
Simply force assembly.

> Is there anything special I can or should do given the raid is holding
> encrypted LVM volumes?  The array is the only PV in a VG holding LVs
> that are LUKS encrypted, within which are (mainly) XFS filesystems

Due to the nature of the failure, which was 4 drives simultaneously
going off line and potentially having partial stripes written, the only
thing you can do is force assembly and clean up the damage, if there is
any.  Best case scenario is that XFS journal replay works, and you maybe
have a few zero length files if any were being modified in place at the
time of the event.  Worse case scenario is directory inodes were being
written and journal replay doesn't recover the damaged inodes.

Any way you slice it, you simply have to cross your fingers and go.  If
you didn't have many writes in flight at the time of the failure, you
should come out of this ok.  You stated multiple XFS filesystems.  Some
may be fine, others damaged.  Depends on what, if anything, was being
written at the time.

> The LVs/filesystems with the data I'd be most upset about losing
> weren't decrypted/mounted at the time.  Is that likely to improve the
> odds of recovery?

Any filesystem that wasn't mounted should not have been touched by this
failure.  The damage should be limited to the filesystem(s) atop the
stripe(s) that were being flushed at the time of the failure.  From your
description, I'd think the damage should be pretty limited, again
assuming you had few writes in flight at the time.

-- 
Stan

