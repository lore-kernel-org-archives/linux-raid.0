From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Chunk size change stop/restart
Date: Wed, 18 Dec 2013 19:31:09 +0100
Message-ID: <20131218183109.GA4670@lazy.lzy>
References: <20131217190019.GA1883@lazy.lzy>
 <20131218093210.46a208a2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131218093210.46a208a2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 18, 2013 at 09:32:10AM +1100, NeilBrown wrote:
> On Tue, 17 Dec 2013 20:00:19 +0100 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi all,
> > 
> > I started the process of changing the chunk
> > size of a RAID-5 array (5 HDDs).
> > 
> > Unfortunately, I unwisely choose a quite slow
> > device for the backup file.
> > 
> > Is it possible, without stopping the array, to
> > stop the "reshape", move the backup file to a
> > faster place and restart the process?
> 
> You might be able to kill the mdadm which over-sees the reshape, move the
> file, then use --grow --continue to continue the reshape.
> But I've never tested this and suspect that something would go wrong.

Hi Neil,

thanks for the answer.

Actually, I've another card to play.
The array is empty in the second half, so I could
try to kill mdadm (which signal? I guess the normal
kill should do) and then restart the reshape, as
soon as the 50% mark is reached.

Assuming something goes wrong, is there a way to
re-start the array forcing (maybe?) the 64k chunk
size (then a repair should simply fix the second
half, I guess).
 
> Stopping, moving, and re-assembling should work.
> 
> Being patient also works,  but can be very difficult.

That was plan A, but I missed by 1 day... :-)

bye,

-- 

piergiorgio
