From: Neil Brown <neilb@suse.de>
Subject: Re: Debian kernel stanza after aptitude kernel upgrade
Date: Thu, 7 Oct 2010 15:16:13 +1100
Message-ID: <20101007151613.05b0a873@notabene>
References: <30D96C04B1444C569D53B7790707D718@DesktopManie>
	<4C98CCCD.80101@seoss.co.uk>
	<20100922062946.7e56d1d1@notabene>
	<4CA1CD67.4040700@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA1CD67.4040700@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "A. Krijgsman" <a.krijgsman@draftsman.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Sep 2010 12:11:35 +0100
Tim Small <tim@seoss.co.uk> wrote:

> On 21/09/10 21:29, Neil Brown wrote:
> >> I think you need to stick the output of
> >>
> >> mdadm --examine --scan
> >>
> >> into /etc/mdadm/mdadm.conf
> >>      
> > It is generally better to use
> >      mdadm --detail --scan
> >
> > for generating mdadm.conf as it is more likely to get the device names
> > right.  And when doing this by hand, always review the output to make sure it
> > looks right.
> >    
> 
> 
> Thanks for that Neil - Debian (and thus Ubuntu) currently uses the 
> output of "mdadm --examine --scan --config=partitions" when 
> autogenerating the mdadm.conf output.  Should this be considered a bug?  
> If so, could you give a bit of detail, and I'll open a bug for the 
> script....
> 
> Thanks,
> 
> Tim.
> 

It all depends on what you want to do.

If you want a config file which described the current configuration, then
"--detail --scan" is definitely the thing to use.
If you want a config file that records what is on the devices currently
attached to the machine, then "--examine --scan" is what you want.

Any use of "--examine --scan" is probably better left to the auto-assembly
stuff in mdadm (mdadm -As).  So Debian should probably be using --detail
--scan.  However without a statement of the exactly purpose and context, one
cannot be certain.

NeilBrown
