From: Andrea Mazzoleni <amadvance@gmail.com>
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
Date: Tue, 7 Jan 2014 12:15:48 +0100
Message-ID: <20140107111548.GD16044@gmail.com>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
 <CAK2H+efOLtq6onYASnZ5DsghVMp5AN70fx_uN8Ha5Wr3RxKx3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK2H+efOLtq6onYASnZ5DsghVMp5AN70fx_uN8Ha5Wr3RxKx3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Andrea Mazzoleni <amadvance@gmail.com>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

On 01/06, Mark Knecht wrote:
>    Question: As an end-user type who currently uses mdadm RAID6, if I
> wanted to set up a dedicated machine to do some SnapRAID testing then
> what's the minimum disk hardware I'd need assuming Linux is just on
> it's own disk?
The patch I sent is not related to SnapRAID. It's the same raid engine,
but this is not going to change how mdadm RAID is working.

When and if this patch will be accepted in the Linux kernel, you can
expect to have mdadm to support triple/quad/and more parity just like RAID5
and RAID6 are supported today.

But at now there is no new functionality to try. We still miss the
required changes inside mdadm, that likely will happen in a second
time.

Ciao,
Andrea
