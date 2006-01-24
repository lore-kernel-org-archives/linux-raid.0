From: Mario =?UTF-8?B?RMO2cmluZw==?= <mario@dedenet.de>
Subject: Re: mdadm-2.2 - kexec problem/bug
Date: Tue, 24 Jan 2006 15:05:21 +0100
Message-ID: <20060124150521.737f490b@snibbles.dedenet.de>
References: <20060123125406.2055fd44@snibbles.dedenet.de>
	<17365.39498.479748.569207@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17365.39498.479748.569207@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

thank you for your response.

exact error messages are not easy, since the messages a) appear only
for a short while or b) are incomplete because it is not possible to
scroll up.


I don't have any dma/irq related problems with my hard disks without a
kexec reboot.
And I don't have any problems with mdadm-2.1 and kexec reboot.


With mdadm-2.2 I get the following message on shutdown (or reboot (with
and
without kexec)):

"mdamd: failed to stop /dev/md1 array, device or resource busy"

I am not sure if that error message comes directly from mdadm or is
filtered by the gentoo script.

Other users have the same problem:
http://forums.gentoo.org/viewtopic-t-360870-highlight-mdadm+stop+array.html


Since mdadm-2.1 does not has this error, I assume that the kexec
problem might be related to this mdadm-2.2 issue.

Do you still need more information about my hardware or is there
anything I can do to get a more precise error message?

Bye,
Mario.



On Tue, 24 Jan 2006 14:08:58 +1100
Neil Brown <neilb@suse.de> wrote:

> On Monday January 23, mario@dedenet.de wrote:
> > Hello :)
> > 
> > when rebooting my gentoo system with mdadm-2.2, I get the following
> > error message on shutdown:
> > 
> > mdadm: fail to stop array /dev/md0: Device or resource busy
> > md0 is my root partition
> > 
> > 
> > /dev/md0 is my root parition.
> > 
> > That is no problem with a real reboot or shutdown.
> > 
> > 
> > But with a "kexec reboot" the rebooted kernel hangs with
> > several dma and irq errors.
> > 
> > The problem does not exist in version mdadm-2.1
> > 
> 
> This does not sound at all like it could be an mdadm issue.  If you
> are getting dma and irq errors then I suspect some low lever device
> driver is misbehaving or getting confused by kexec.
> 
> > 
> > I am not sure if this is the right place for reporting this issue..
> 
> A good place to start, but I don't think you'll find the answer
> here. If there is a 'kexec' mailing list, try there, otherwise
> linux-kernel@vger.kernel.org.
> Also, include lots more details.  Precise error messages, what sorts
> of drives and controllers you have, and the exact sequence of events.
> 
> NeilBrown
> 
> 
> > 
> > 
> > Regards,
> > Mario.
> > -
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
