From: Phil Turmel <philip@turmel.org>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Mon, 01 Oct 2012 08:40:18 -0400
Message-ID: <50698F32.1080001@turmel.org>
References: <loom.20120930T105755-205@post.gmane.org> <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se> <50689B6C.8000307@ejane.org> <CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com> <50689C9B.1010603@ejane.org> <5068AB81.1060103@turmel.org> <5068D464.4030504@ejane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5068D464.4030504@ejane.org>
Sender: linux-raid-owner@vger.kernel.org
To: EJ Vincent <ej@ejane.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi EJ,

On 09/30/2012 07:23 PM, EJ Vincent wrote:
> On 9/30/2012 4:28 PM, Phil Turmel wrote:

>> Do you have *any* dmesg output from the old system?  Or dmesg from the
>> very first boot under 12.04?  That might have enough information to
>> shorten your search.
>>
>> In the future, you should record your setup by saving the output of
>> "mdadm -D" on each array, "mdadm -E" on each member device, and the
>> output of "ls -l /dev/disk/by-id/"
>>
>> Or try my documentation script "lsdrv". [1]
>>
>> HTH,
>>
>> Phil
>>
>> [1] http://github.com/pturmel/lsdrv
> 
> Hi Phil,
> 
> Unfortunately I don't have any dmesg log from the old system or the
> first boot under 12.04.
> 
> Getting my system to boot at all under 12.04 was chaotic enough, with
> the overly-aggressive /usr/share/initramfs-tools/scripts/mdadm-functions
> ravaging my array and then dropping me to a busybox shell over and over
> again.  I didn't think to record the very first error.

I'm not prepared to condemn the 12.04 initramfs--I really don't think it
is a factor in this crisis.  The critical part is the degraded reboot bug.

> Here's an observation of mine, disks: /dev/sdb1, /dev/sdi1, and
> /dev/sdj1 don't have the Raid level "-unknown-", neither are they
> labeled as spares.  They are in fact, labeled clean and appear
> *different* from the others.
> 
> Could these disks still contain my metadata from 10.04?  I recall during
> my installation of 12.04 I had anywhere from 1 to 3 disks unpowered, so
> that I could drop in a SATA CD/DVDRW into the slot.

Leaving disks unpowered sounds like a key factor in your crisis.  Raid6
can't operate with more than two missing, and won't assemble if any disk
disappears between shutdown and the next boot.  (Must be forced.)

So your array would only partially assemble under 12.04 due to
deliberately missing drives, then you rebooted with a kernel that has a
problem with that scenario.

The disks very likely do have useful metadata, but no disk has all of
it.  It might reduce the permutations you need to try.  If you share
more information about your system layout, some educated first guesses
might be possible, too.  The output of "mdadm -E" for every drive, and
lsdrv for an overview.

> I am downloading 10.04.4 LTS and will be ready to use it soon.  I fear
> having to do permutations-- 9! (factorial) would mean 362,880
> combinations.  *gasp*

Phil

