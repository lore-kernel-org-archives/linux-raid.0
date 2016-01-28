From: Shaohua Li <shli@kernel.org>
Subject: Re: Problem with array raid10 array resync on 4.4.0 (keeps reyncing
 each reboot)
Date: Thu, 28 Jan 2016 10:25:22 -0800
Message-ID: <20160128182522.GB23378@kernel.org>
References: <56A78786.10103@Free.fr>
 <20160126233133.GB12721@kernel.org>
 <56A870AD.4070400@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56A870AD.4070400@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Valette <eric.valette@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 27, 2016 at 08:24:29AM +0100, Eric Valette wrote:
> On 27/01/2016 00:31, Shaohua Li wrote:
> >On Tue, Jan 26, 2016 at 03:49:42PM +0100, Eric Valette wrote:
> >>Hi,
> >>
> >>My raid 10 array (5 disk with one spare) was doing a  resync after an
> >>upgrade to 4.4.0 from 4.1.15. The resync progress was steady and at the end
> >>the /proc/mdstat was apparently complete but when rebooting, it started
> >>resycing over and over. I noticed my dmesg was totally filled with raid10
> >>conf printout message so it was impossible to trace anything else.
> >>
> >>Did a resync test with 3.14.58 (because I knew it had worked for resync
> >>before and was still available as a boot option)  and the array was
> >>correctly rebuild.
> >>Runs fine with 4.1.16 now.
> >>
> >>Please CC me as I'm not subscribed.
> >
> >Could you please provide more info, like mdadm -D /dev/md0 in v4.4? If you run
> >a stop/reassemble, does the resync start?
> 
> I'm not going to retry kernel 4.4.0 on this device as I'm no more confident
> about raid10 support with this 4.4 version.

Thanks! I know switching to a kernel which is not working well is risky, but
the info from 4.1 doesn't have enough info for debuging. I also tried to
reproduce the issue locally, but no success. Did you have any other info which
could help debugging, for example special config?

Thanks,
Shaohua
