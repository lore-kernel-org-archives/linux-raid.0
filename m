From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Buffer I/O error on dev md5, logical block 7073536, async page
 read
Date: Sun, 30 Oct 2016 18:02:42 +0100
Message-ID: <20161030170242.GA5724@metamorpher.de>
References: <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de>
 <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <20161030164342.GC28648@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161030164342.GC28648@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 30, 2016 at 09:43:42AM -0700, Marc MERLIN wrote:
> Right.
> There should be some --update=no-bbl --force if the admin knows the bad
> block list is wrong and due to IO issues not related to the drive.

Good point. And hey, there it is.

mdadm.c

|                       	if (strcmp(c.update, "bbl") == 0)
|                               	continue;
|                       	if (strcmp(c.update, "no-bbl") == 0)
|                                continue;
|                       	if (strcmp(c.update, "force-no-bbl") == 0)
|                               	continue;

force-no-bbl. It's in mdadm v3.4, not sure about older ones.

If I stumbled across that one before then I forgot about it.

Good luck
Andreas Klauer
