From: David Brown <david@westcontrol.com>
Subject: Re: SSD - TRIM command
Date: Wed, 09 Feb 2011 14:29:12 +0100
Message-ID: <iiu4rc$9ju$1@dough.gmane.org>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com> <4D517F4F.4060003@gmail.com> <4D5245DF.4020401@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5245DF.4020401@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/2011 08:44, Stan Hoeppner wrote:
> maurice put forth on 2/8/2011 11:37 AM:
>> On 2/7/2011 1:07 PM, Roberto Spadim wrote:
>>> hi guys, could md send TRIM command to ssd? using ext4 discart
>>> mount option? if i mix ssd and hd, could this TRIM be rewrite to
>>> non TRIM compatible disks?
>>>
>> I have read that using md with SSDs is not a great idea: Form the
>> Fedora 14 documentation:
>
> Using any RAID level but pure striping with SSDs is a bad idea, for
> the exact reason in that documentation:  excessive writes.
>
> SSD - Solid State Drive
>
> Note the first two words.  Solid state device = integrated circuit.
> ICs, including those comprised of flash memory transistors, have
> totally different failure modes than spinning rust disks, SRDs, or
> "plain old mechanical hard drives".
>
> RAID'ing SSDs with any data duplicative RAID level, any mirroring or
> parity RAID levels, _decreases_ the life of all SSDs in the array.
> This is the opposite effect of what you want:  reliability and
> lifespan.
>
> People have a misconception that SSDs are like hard disks.  The only
> thing they have in common is that both store data and they can have a
> similar interface (SATA).  The similarities end there.
>
> RAID is not a proper method of extending the life of SSD storage nor
> protecting the data on SSD devices.  If you want to pool all the
> capacity of multiple SSDs into a single logical device, use RAID 0 or
> spanning, _not_ a mirror or parity RAID level.  If you want to
> protect the data, snap it to a single large SATA drive, or a D2D
> backup array, and then to tape.
>

First off, let me agree with you that backup is important no matter what 
you use as your primary storage.

But beyond that, you've got a basic assumption wrong here.

Good quality, modern SSDs do not have write-endurance issues.  It's a 
thing of the past.  Internally, of course, the flash /does/ have 
endurance limits.  But these are high (especially with SLC devices 
rather than MLC devices), and the combination of ECC, wear-levelling and 
redundant blocks means that you can write to these devices continuously 
at high speed for /years/ before endurance issues become visible by the 
host.  An additional effect of the extensive ECC is that undetected read 
errors are much less likely than with hard disks - when a failure /does/ 
occur, you know it has occurred.

Many SSD models suffer from a certain amount of performance degradation 
when they have been used for a while.  Intel's devices were notorious 
for this, though apparently they are better now.  But that's a speed 
issue, not a reliability or lifetime issue.

SSDs (again, I refer to good quality modern devices - earlier models had 
more problems) are inherently more reliable than HDs, and have longer 
expected lifetimes.  This means that it is often fine to put your SSDs 
in a RAID0 combination - you still have a greater reliability than you 
would with a single HDD.

However, SSDs are not infallible - using redundant RAID with SSDs is a 
perfectly valid setup.  Obviously you will have a whole disks worth of 
extra writes when you set up the RAID, and redundant writes means more 
writes, but the SSDs will handle those writes perfectly well.


There is plenty of scope for md / SSD optimisation, however.  Good TRIM 
support is just one aspect.  Other points include matching stripe sizes 
to fit the geometry of the SSD, and taking advantage of the seek speeds 
of SSD (this is particularly important if you are mirroring an SSD and 
an HD).


