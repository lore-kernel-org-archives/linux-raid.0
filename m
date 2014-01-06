From: Phil Turmel <philip@turmel.org>
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
Date: Mon, 06 Jan 2014 12:02:03 -0500
Message-ID: <52CAE18B.8020701@turmel.org>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Mazzoleni <amadvance@gmail.com>, neilb@suse.de
Cc: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

On 01/06/2014 04:31 AM, Andrea Mazzoleni wrote:
> Hi,
> 
> This is a port to the Linux kernel of a RAID engine that I'm currently using
> in a hobby project called SnapRAID. This engine supports up to six parities
> levels and at the same time maintains compatibility with the existing Linux
> RAID6 one.

FWIW, your patch 1/2 doesn't seem to have gone through on linux-raid,
although I saw it on lkml.  Probably a different file size limit, as
that's a very large patch.

You might want to break the next submission into smaller parts.  That
might help people review it, too.

Thanks for doing this work!

Phil
