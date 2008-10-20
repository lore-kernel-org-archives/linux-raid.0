From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 0 md device still active after pulled drive
Date: Mon, 20 Oct 2008 11:35:33 +1100
Message-ID: <18683.53845.702858.972766@notabene.brown>
References: <8CAFECFAC51849A-1CD4-454@FWM-D03.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from thomas62186218@aol.com on Friday October 17
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 17, thomas62186218@aol.com wrote:
> Hi All,
> 
> I have run into a most unusual behavior, where mdadm reports a RAID 0 
> array that is missing a drive as "Active".

Not unusual at all.  mdadm has always behaved this way.

There is nothing that 'md' can ever do about a failed drive in a
raid0, so it doesn't bother doing anything.  At all.
As far as md is concerned, the drive is still an active part of the
array.  It will still try to send appropriate IO requests to that
device.  If they fail (e.g. because the device doesn't actually
exist), then md will send that error message back.
> 
> 
> Conclusion: Why does mdadm report a drive failure on RAID 0 but not 
> make the md device as Inactive or otherwise failed?

where exactly did "mdadm report a drive failure" on the RAID0 ??


As always,  if you think the documentation could be improved to reduce
the chance of this sort of confusion, or if the output of mdadm could
make something more clear, I am open to constructive suggestions (and
patches).

NeilBrown
