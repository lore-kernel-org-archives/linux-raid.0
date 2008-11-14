From: Neil Brown <neilb@suse.de>
Subject: Re: Should we be trying re-write on write errors?
Date: Sat, 15 Nov 2008 08:58:46 +1100
Message-ID: <18717.62614.341600.906790@notabene.brown>
References: <200811142130.mAELU6Io009544@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from greg@enjellic.com on Friday November 14
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 14, greg@enjellic.com wrote:
> Hi Neil, hope the week is ending well for you and the rest of the
> denizens on the linux-raid list.
> 
> Somewhat of a Gedanken question for you.
> 
> We currently attempt a re-write on read error for volumes which have
> redundancy, ie. RAID[156] etc, on the bet that we can force a bad
> sector remap.  Should we be attempting that (or do we) on a write
> error as well?

I don't think so.
By the time md/raid gets an error status, lower levels (Whether driver
or firmware) should have retried as much as in appropriate.  Doing
further retries at the md level should be pointless.

For reads, we do retry.  But the purpose is to find out exactly which
block failed so that we can just re-write that block.  There is no
expectation that a block which previously failed a read will now
succeed.

Similarly there is no reason to expect that a block which previously
failed a write will now succeed.

I suggest that you might like to discuss your particular case with the
author of the driver for the device.  Maybe the driver should be
retrying.  Maybe the firmware is doing the wrong thing.

After all, you wouldn't expect every different filesystem to retry all
failed writes, would you?


> 
> BTW much thanks for the existing re-write code.  Countless mornings
> I have said 'gee that Neil Brown was clever' when I see that one of
> our machines cleaned up a potential problem before it became a bigger
> one.
:-)
To be honest, that code was largely because people kept complaining
about read errors being too fatal and wanted something done.  The only
way to stop the flood of complaints was to fix something :-)

> 
> Best wishes for a pleasant weekend.

And for you!

NeilBrown
