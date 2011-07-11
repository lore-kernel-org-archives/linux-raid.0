From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Mon, 11 Jul 2011 09:54:16 +0200
Message-ID: <20110711075416.GA32187@apartia.fr>
References: <20110706161228.GA1491@apartia.fr>
 <4E1494BB.9060101@turmel.org>
 <20110707090540.GA7288@apartia.fr>
 <4E15A980.3060508@turmel.org>
 <20110707130917.GA18812@apartia.fr>
 <4E15B576.9040004@turmel.org>
 <20110708054045.GA28420@maude.comedia.it>
 <20110710120350.GA30568@apartia.fr>
 <4E199AEB.4030606@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E199AEB.4030606@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 10, 2011 at 08:28:27AM -0400, Phil Turmel wrote:
> On 07/10/2011 08:03 AM, Louis-David Mitterrand wrote:
> > On Fri, Jul 08, 2011 at 07:40:45AM +0200, Luca Berra wrote:
> >>> This is important.  When I computed the sector count for the linear mapping, I just took 2048 off the end.  You may want to select a sector count that aligns the endpoint.
> >> but the xfs sb should be at sector 0
> > 
> > So what should I change to the dmsetup command to make it work?
> 
> He means (not to put words in Luca's mouth...) that the precise
> endpoint of the mapped volume shouldn't matter to fsck.xfs.  Changing
> device order in the raid is probably your only hope of recovery.  The
> dmsetup exercise was a blind alley.
> 
> Luca also pointed out that the problem array is named "grml" which
> means that it was created with grml, not your original system (zenon).
> That suggests that "mdadm --create" was used under grml, and the
> member devices were specified in an order differing from the original
> install.  If that "mdadm --create" didn't include the "--assume-clean"
> option, then the parity blocks are almost certainly recomputed, and
> your data destroyed.  Otherwise, you can try "mdadm --create
> --assume-clean" with other combinations of device order to try to find
> the "right" one.
> 
> I recommend trying "mdadm --create --assume-clean" with the devices in
> the same order as shown by lsdrv for the zenon array.

That clinched the deal!

By reordering the md1 array according to the working 'zenon' md2 array I
was able to unlock it with cryptsetup. However the xfs filesystem was
too damaged: an xfs_repair sent everything in lost+found.

That lsdrv tool is really useful, I'll keep it my box.

Thanks,
