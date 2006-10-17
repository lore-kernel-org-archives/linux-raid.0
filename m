From: Neil Brown <neilb@suse.de>
Subject: Re: resync starts over after each reboot (2.6.18.1)?
Date: Tue, 17 Oct 2006 19:23:55 +1000
Message-ID: <17716.41259.239292.413627@cse.unsw.edu.au>
References: <45349861.4010208@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomasz Chmielewski on Tuesday October 17
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 17, mangoo@wpkg.org wrote:
> I just set up a new Debian unstable box.
> It's running 2.6.18.1 kernel.
> 
> I created RAID-1 on two disks, with no data or filesystem on it.
> As I'm still experimenting with the box, I reboot it quite frequently.
> 
> I noticed that RAID-1 resync starts from the very beginning after each 
> reboot. Is it normal?

No.
Has the resync finished when you shut down?
How do you shut down?
Can you post the kernel logs from boot up to when the resync has
started?

NeilBrown
