From: Shaohua Li <shli@kernel.org>
Subject: Re: Problem with array raid10 array resync on 4.4.0 (keeps reyncing
 each reboot)
Date: Tue, 26 Jan 2016 15:31:33 -0800
Message-ID: <20160126233133.GB12721@kernel.org>
References: <56A78786.10103@Free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56A78786.10103@Free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Valette <Eric.Valette@Free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 26, 2016 at 03:49:42PM +0100, Eric Valette wrote:
> Hi,
> 
> My raid 10 array (5 disk with one spare) was doing a  resync after an
> upgrade to 4.4.0 from 4.1.15. The resync progress was steady and at the end
> the /proc/mdstat was apparently complete but when rebooting, it started
> resycing over and over. I noticed my dmesg was totally filled with raid10
> conf printout message so it was impossible to trace anything else.
> 
> Did a resync test with 3.14.58 (because I knew it had worked for resync
> before and was still available as a boot option)  and the array was
> correctly rebuild.
> Runs fine with 4.1.16 now.
> 
> Please CC me as I'm not subscribed.

Could you please provide more info, like mdadm -D /dev/md0 in v4.4? If you run
a stop/reassemble, does the resync start?

Thanks,
Shaohua
