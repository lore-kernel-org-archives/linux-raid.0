From: David Brown <david@westcontrol.com>
Subject: Re: Software RAID and TRIM
Date: Tue, 19 Jul 2011 17:06:12 +0200
Message-ID: <j046mj$1pn$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de> <j012fa$6k6$1@dough.gmane.org> <j01ssr$j1i$1@dough.gmane.org> <j024fe$4va$1@dough.gmane.org> <j03ipg$uqk$1@dough.gmane.org> <j03m2p$jn1$1@dough.gmane.org> <j041j1$ttf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j041j1$ttf$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/07/2011 15:41, Lutz Vieweg wrote:
> On 07/19/2011 12:22 PM, David Brown wrote:
>>> Because of those effects on the block-IO-queue, the user-space
>>> work-around we implemented to discard the SSDs our RAID-1s consist of
>>> will not discard "one area on all SSDs at a time", but rather iterate
>>> first through all unused areas on one SSD, then iterate through the
>>> same list of areas on the second SSD.
>>
>> Do you take the arrays off-line during this process, or at least make
>> them read-only?
>
> No, we keep them online and writeable.
>
>> If not, how do you ensure that the lists are valid?
>
> The discard procedure works by..:
>
> - use SYS_fallocate to allocate the free space on the device (minus
> some safety margin for the writes that will happen during the procedure)
> for a temporary file (notice that with fallocate on XFS, you can
> allocate space for a file without actually ever writing to it)
>
> - use ioctl FIEMAP to get a list of the logical blocks that were
> allocated
>
> - use ioctl BLKDISCARD to discard these blocks
>
> - remove the temporary file
>
> Since the blocks to discard are allocated for the temporary
> file during the procedure, they will not be used otherwise.
>
> Obviously, we would still prefer using "fstrim", because then
> there would be no need for that temporary file, the "safety margin"
> and a temporary high fill level of the filesystem.
>
> Regards,
>
> Lutz Vieweg
>

It certainly sounds like a safe procedure, but I can see why you feel 
it's not quite as elegant as it could be.  You will also be "discarding" 
blocks that have never been written (at least, not since the last 
discard...) - is there much overhead in that?


