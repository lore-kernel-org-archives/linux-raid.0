From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 recovery fails with 2.6 kernel
Date: Mon, 20 Oct 2003 16:15:27 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16275.32127.862408.701013@notabene.cse.unsw.edu.au>
References: <7da.3f929f6e.d36f3@altium.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dick Streefland on Sunday October 19
To: Dick Streefland <dick.streefland@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 19, spam@streefland.xs4all.nl wrote:
> When I mark one of the devices in a RAID1 array faulty, remove it, and
> re-add it, recovery starts, but stops too early, leaving the array in
> degraded mode. I'me seeing this in the latest 2.6.0 kernels, including
> 2.6.0-test8. The 2.4.22 kernel works OK, although the array is marked
> "dirty" (?). Below is a script to reproduce the problem, followed by
> the output of the script. I'm using mdadm-1.3.0.

Thanks for providing a script...
It works fine for me (2.6.0-test8).

I don't suppose there is anything in the kernel logs about write
errors on loop2 ???

Does it fail consistently for you, or only occasionally?

NeilBrown
