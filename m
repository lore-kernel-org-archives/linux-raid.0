From: Andrea Mazzoleni <amadvance@gmail.com>
Subject: Re: [RFC v2 0/2] New RAID library supporting up to six parities
Date: Tue, 7 Jan 2014 12:06:05 +0100
Message-ID: <20140107110605.GC16044@gmail.com>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
 <52CA9A97.4000803@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52CA9A97.4000803@shiftmail.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

On 01/06, joystick wrote:
> Just by looking at the Subjects, it seems patch number 0/1 is
> missing. It might have not gotten through to the lists, or be a
> numbering mistake.
The patch files can be also downloaded from: http://snapraid.sourceforge.net/linux/v2/

Sorry about that,

> Does your code also support (shortcut) RMW as opposed to RCW, for
> all parities?
At now no. But it can be easily extended to add the parity computation
of a single disk in a set of already computed parities and then provide the
required support for RMW.

With SSSE3 this can be implemented in a very efficient way.

Ciao,
Andrea

