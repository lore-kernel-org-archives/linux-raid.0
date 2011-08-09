From: Daniel Frey <djqfrey@gmail.com>
Subject: Re: mdadm forces resync every boot
Date: Tue, 09 Aug 2011 12:34:30 -0700
Message-ID: <4E418BC6.7080600@gmail.com>
References: <4E3C06D1.6030301@gmail.com> <20110809093437.299036be@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110809093437.299036be@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/08/11 16:34, NeilBrown wrote:
> On Fri, 05 Aug 2011 08:05:53 -0700 Daniel Frey <djqfrey@gmail.com> wrote:
> 
>> Hi all,
>>
>> I've been fighting with my raid array (imsm - raid10) for several weeks
>> now. I've now replaced all four drives in my array as the constant
>> rebuilding caused a smart error to trip on the old drives; unfortunately
>> mdadm is still resyncing the array at every boot.
>>
>> One thing I would like to clarify is does mdadm need to disassemble the
>> array before reboot. At this point, I can't tell if my system is
>> currently doing this. Googling around it seems some say that this step
>> is unnecessary.
> 
> With md arrays using "native" metadata you don't need to be too careful
> shutting down.  This is probably what you found by googling.
> 
> With IMSM metadata it is a little easier to get it "wrong" though it should
> normally work correctly.
> 
> There is a program "mdmon" which communicates with the kernel and updates the
> metadata on the devices.
> 
> When there have been no writes for a little while, mdmon will notice and mark
> the array as 'clean'.  It will then mark it 'dirty' before the first write is
> allowed to proceed.
> On a clean shutdown of the array it will mark that array as 'clean'.
> 
> But for you, the system shuts down with the array marked 'dirty'.  This
> suggests that on your machine 'mdmon' is being killed while the array is
> still active.
> 
> Presumably your root is on the IMSM RAID10 array?  When the root filesystem
> is marked 'read only' it will probably write to the filesystem to record that
> a fsck is not needed.  So the array will be 'dirty'.  If you then halt before
> mdmon has a chance to mark the array 'clean' you will get exactly the result
> you see.

That's correct, my root is on the imsm raid10 array, along with my
dual-boot of Windows Vista. If I didn't want to boot Vista, I'd just be
using native mdadm like I always have.

> 
> If you arrange that the shutdown script runs
>   mdadm --wait-clean --scan
> 
> after marking the root filesystem readonly, it will wait until all arrays are
> recorded as 'clean'.

I've done some quick poking around and I do not see anything like that.
I'll look into it a little more and, if necessary, file a bug with the
distro.

> 
> This should fix your problem.
> 
> What distro are you using?  openSUSE has this command in /etc/init.d/reboot.

I've used gentoo for as long as I can remember. I've never had an issue
with mdadm on gentoo until I started using the imsm raid, so it's very
possible that the above command is missing from the shutdown sequence.

Thanks Neil! With this bit of information I should be able to get it
resolved. I do have both mdadm and dmraid kernels on this machine now,
so testing shouldn't be too hard.

> 
> NeilBrown
