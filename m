From: Luca Berra <bluca@comedia.it>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 30 Oct 2007 07:55:49 +0100
Message-ID: <20071030065549.GA13545@percy.comedia.it>
References: <20071026095417.GC32550@percy.comedia.it> <1193424779.10336.287.camel@firewall.xsintricity.com> <20071026223046.GB8210@boogie.lpds.sztaki.hu> <1193531160.10336.397.camel@firewall.xsintricity.com> <20071028141336.GC22861@percy.comedia.it> <1193593675.10336.404.camel@firewall.xsintricity.com> <20071029084118.GC15475@percy.comedia.it> <1193671853.10336.428.camel@firewall.xsintricity.com> <20071029214416.GB24635@percy.comedia.it> <1193699142.10336.503.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193699142.10336.503.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 29, 2007 at 07:05:42PM -0400, Doug Ledford wrote:
>And I agree -D has less chance of finding a stale superblock, but it's
>also true that it has no chance of finding non-stale superblocks on
Well it might be a matter of personal preference, but i would prefer
an initrd doing just the minumum necessary to mount the root filesystem
(and/or activating resume from a swap device), and leaving all the rest
to initscripts, then an initrd that tries to do everything.

>devices that aren't even started.  So, as a method of getting all the
>right information in the event of system failure and rescuecd boot, it
>leaves something to be desired ;-)  In other words, I'd rather use a
>mode that finds everything and lets me remove the stale than a mode that
>might miss something.  But, that's a matter of personal choice.
In case of a rescuecd boot, you will probably not have any md devices
activated, and you will probably run "mdadm -Es" to check what md are
available, the data should be still on the disk, else you would be hosed
anyway.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
