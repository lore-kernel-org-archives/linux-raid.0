From: Sam Bingner <sam@bingner.com>
Subject: Re: mdraid autodetect partially failing after disk replacement
Date: Fri, 10 May 2013 04:08:44 +0000
Message-ID: <7B5C6400-7359-406E-A798-720B31F5B982@bingner.com>
References: <518AF9EB.7040402@burg.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <518AF9EB.7040402@burg.in>
Content-Language: en-US
Content-ID: <C0A0975F170A4F45AF2D2B899E932F16@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ricky Burgin <ricky@burg.in>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On May 8, 2013, at 3:20 PM, Ricky Burgin <ricky@burg.in> wrote:

> Hello again,
> 
> Little bit of progress since I last dropped a message in (sorry for the
> duplicate, didn't think the initial one got through).
> 
> The kernel has mdraid built into it and all disks are using 0.90
> superblocks, all 'fd' partitions, but only 2 or 4 disks are being
> recognised and applied to the freshly created raid array which works
> fine when mounted on any other OS.
> 
> Any suggestions for what could cause disks to be overlooked by mdraid
> before the root device is even attempted to be mounted would be very
> helpful, I'm now totally at a loss as to what to do from here.
> 
> Kind regards,
> Ricky Burgin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Is it possible that you still have 1.x superblocks on two drives that are being detected before the 0.9 superblocks on this OS?  I don't know if this is or is not possible, but that is the only strangeness I see from your prior posts etc.

You should probably boot that version of CentOS's rescue mode and see if you have the same issues there... 

Sam