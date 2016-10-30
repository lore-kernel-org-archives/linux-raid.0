From: Marc MERLIN <marc@merlins.org>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl can't be used?
Date: Sun, 30 Oct 2016 10:16:54 -0700
Message-ID: <20161030171654.GE28648@merlins.org>
References: <20161030153857.GB28648@merlins.org> <20161030161929.GA5582@metamorpher.de> <20161030164342.GC28648@merlins.org> <20161030170242.GA5724@metamorpher.de> <20161030021614.asws67j34ji64qle@merlins.org> <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org> <20161030161929.GA5582@metamorpher.de> <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org> <20161030171234.GD28648@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161030170242.GA5724@metamorpher.de> <20161030171234.GD28648@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 30, 2016 at 10:12:34AM -0700, Marc MERLIN wrote:
> Hi Neil,
> 
> Could you offer any guidance here? Is there somethign else I can do to clear
> those fake bad blocks (the underlying disks are fine, I scanned them)
> without rebuilding the array?

On Sun, Oct 30, 2016 at 06:02:42PM +0100, Andreas Klauer wrote:
> > There should be some --update=no-bbl --force if the admin knows the bad
> > block list is wrong and due to IO issues not related to the drive.
> 
> Good point. And hey, there it is.
> 
> mdadm.c
> 
> |                       	if (strcmp(c.update, "bbl") == 0)
> |                               	continue;
> |                       	if (strcmp(c.update, "no-bbl") == 0)
> |                                continue;
> |                       	if (strcmp(c.update, "force-no-bbl") == 0)
> |                               	continue;
> 
> force-no-bbl. It's in mdadm v3.4, not sure about older ones.

Oh, very nice, thank you. It's not in the man page, but it works:

myth:~# mdadm --assemble --update=force-no-bbl /dev/md5
mdadm: /dev/md5 has been started with 5 drives.
myth:~# 
myth:~# mdadm --examine-badblocks /dev/sd[defgh]1
No bad-blocks list configured on /dev/sdd1
No bad-blocks list configured on /dev/sde1
No bad-blocks list configured on /dev/sdf1
No bad-blocks list configured on /dev/sdg1
No bad-blocks list configured on /dev/sdh1

Now I'll make sure to turn off this feature on all my other arrays
in case it got turned on without my asking for it.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
