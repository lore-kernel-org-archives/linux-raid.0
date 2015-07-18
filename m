From: Steven Reddie <steven.reddie@gmail.com>
Subject: Re: mdadm --create parameter ordering
Date: Sat, 18 Jul 2015 13:08:56 +1000
Message-ID: <CAFcup8FXqDuja0eH9QajTzUR7VfNEA5c3yNtpd+tL+eBzMyYYw@mail.gmail.com>
References: <CAFcup8E3iKxb8H-Fz76bKJQhjmhq1FuVu11rEPb-k=g2U_nX=w@mail.gmail.com>
	<20150713105928.GA19366@cthulhu.home.robinhill.me.uk>
	<55A3BA80.50505@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55A3BA80.50505@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Robin and Phil, I've verified that the parity information did
in fact get recalculated and written to different disks, though I'm
confident that I can still recover by reversing this. I expect that I
could manually reconstruct the metadata and superblocks if I needed to
but before I began I took a dd backup of the first 1GB of each
physical disk, each partition, and the MD device, and I also have the
/etc/space/*.xml files, so I expect I have enough to restore these.
I'll start a new thread to ask about the best way to proceed.

Thanks,

Steven


On Mon, Jul 13, 2015 at 11:17 PM, Phil Turmel <philip@turmel.org> wrote:
> On 07/13/2015 06:59 AM, Robin Hill wrote:
>
> [snip /]
>
> Let me elaborate on one of Robin's comments:
>
>> The --assume-clean option will prevent parity calculation (as it assumes
>> that the parity on disk is already correct), which may be what you're
>> after. It should only be used it you're absolutely certain of the data
>> though, as it can lead to large-scale corruption otherwise.
>
> It is not enough to be certain of the order to use --create
> --assume-clean on existing data.  You must also be certain of superblock
> type, chunk size, data offset, and layout option.
>
> Data loss due to unwise use of --create has a history of bad outcomes.
> It destroys the previous metadata on array members, metadata that is
> almost always needed to recover damaged arrays.  The --create option
> should *never* be used on an array with important data without first
> asking for advice on this list.
>
> Phil
