From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: LVM and Raid5
Date: Mon, 21 Sep 2009 10:33:49 -0400
Message-ID: <170fa0d20909210733p2e3e797cvb60af2e9bd153fda@mail.gmail.com>
References: <f5d1f90a0909160122j32569fb8g9e2a212532ea8604@mail.gmail.com>
	 <4AB22DA3.2090901@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB22DA3.2090901@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: Linux Raid Study <linuxraid.study@gmail.com>, linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On Thu, Sep 17, 2009 at 8:37 AM, Michal Soltys <soltys@ziu.info> wrote:
> Linux Raid Study wrote:
>>
>> Hello:
>>
>> Has someone experimented with LVM and Raid5 together (on say, 2.6.27)?
>> Is there any performance drop if LVM/Raid5 are combined vs Raid5 alone?
>>
>> Thanks for your inputs!
>
> Few things to consider when setting up LVM on MD raid:
>
> - readahead set on lvm device
>
> It defaults to 256 on any LVM device, while MD will set it accordingly to
> the amount of disks present in the raid. If you do tests on a filesystem,
> you may see significant differences due to that. YMMV depending on the type
> of used benchmark(s).
>
> - filesystem awareness of underlying raid
>
> For example, xfs created on top of raid, will generally get the parameters
> right (stripe unit, stripe width), but if it's xfs on lvm on raid, then it
> won't - you will have to provide them manually.
>
> - alignment between LVM chunks and MD chunks
>
> Make sure that extent area used for actual logical volumes start at the
> boundary of stripe unit - you can adjust the LVM's metadata size during
> pvcreate (by default it's 192KiB, so with non-default stripe unit it may
> cause issues, although I vaguely recall posts that current LVM is MD aware
> during initialization). Of course LVM must itself start at the boundary for
> that to make any sense (and it doesn't have to be the case - for example if
> you use partitionable MD).

All of the above have been resolved in recent LVM2 userspace (2.02.51
being the most recent release with all these addressed).  The last
issue you mention (partitionable MD alignment offset) is also resolved
when a recent LVM2 is coupled with Linux 2.6.31 (which provides IO
Topology support).

Mike
