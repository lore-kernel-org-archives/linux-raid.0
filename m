From: "Richard B. Pyne" <rpyne@kinfolk.org>
Subject: Re: system startup hangs
Date: Thu, 08 Dec 2011 09:16:12 -0700
Message-ID: <4EE0E2CC.6090107@kinfolk.org>
References: <4EDFEACD.3010806@kinfolk.org> <20111208122154.GA12445@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111208122154.GA12445@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/8/2011 5:21 AM, Robin Hill wrote:
> On Wed Dec 07, 2011 at 03:38:05PM -0700, Richard B. Pyne wrote:
>> EXT4-fs (md0): mounted filesystem with ordered data mode.  Opts: (null)
>> VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
>> freeing unused kernel memory: 472k freed
>>
>> at which point it just hangs. No more disk access, no more messages.
>>
>> I currently have md0 for / md1 for /home md2 for /usr md3 for /var and
>> md4 on which I plan on running lvm to allocate to other system needs.
>>
>> Any advice, insights and/or direction will be greatly appreciated.
>>
> I've been bitten by this one myself recently. I suspect you've failed to
> copy over the required underlying /dev entries. You need at least
> /dev/console and /dev/null on the rootfs - at this stage the tmpfs
> hasn't been mounted on /dev and udev hasn't created all the dev nodes.
>
> Cheers,
>      Robin
That was the problem, Thank you very much!

Now lilo is telling me that I must have my boot on a RAID1 device even 
though I have it on a non-raid drive and partition.

--Richard

