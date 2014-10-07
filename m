From: Errol Neal <eneal@businessgrade.com>
Subject: Re: auto assemble in read-only mode?
Date: Tue, 7 Oct 2014 08:31:34 -0400
Message-ID: <1412685094488232500@businessgrade.com>
References: <1412600795583058500@businessgrade.com>
	<1412664991898536500@businessgrade.com>
 <20141007181520.359d939b@notabene.brown>
Reply-To: eneal@businessgrade.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141007181520.359d939b@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 10/07/2014 03:15 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 7 Oct 2014 02:56:31 -0400 Errol Neal <eneal@businessgrade.com> wrote:
> 
> > On Mon, 10/06/2014 09:06 AM, Errol Neal <eneal@businessgrade.com> wrote:
> > > hi folks. is it possible to assemble an md device in read-only mode? 
> > > after an array has been assembled, I know I can mark it as readonly with --misc -o /dev/md0 for example, but only after its been assembled it seems..
> > > 
> > 
> > Hi again. No thoughts here? 
> 
> Not even 18 hours since you last asked - what do you thing this is? The
> Internet :-)

HAHA. I tend to feel ignored on large mailing lists lol. Need to see my therapist again ;)
 
> 
> > I'm need to run a RAID1 device on two independent nodes (shared storage) and I'd like to assemble the device on the "slave" node in read-only mode to prevent any sync actions and etc. 
> 
> Did you try adding the "--readonly" option to your --assemble command?
> (Always best to report everything you tried and how it failed - requires less
> guess work). 
 
I did that previously and mdadm told me that  "option --readonly not valid in assemble mode". E.g. "mdadm --assemble --scan --readonly". 
The readonly flag seems like it can only be used after a device has been assembled. So for example, after the device has been assembled, I can 
run mdadm --misc -o /dev/md0 but that is not always safe for my use case. 


 
> I hope you don't expect too much of a filesystem mounted from such an array
> while the  other node is writing to the array...
> 

I don't. It will be read-only until the pacemaker RA promotes the slave. 
