From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Buffer I/O error on dev md5, logical block 7073536, async page
 read
Date: Sun, 30 Oct 2016 10:33:37 +0100
Message-ID: <20161030093337.GA3627@metamorpher.de>
References: <20161030021614.asws67j34ji64qle@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161030021614.asws67j34ji64qle@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 29, 2016 at 07:16:14PM -0700, Marc MERLIN wrote:
> Can someone tell me how this is possible?
> More generally, is it possible for the kernel to return an md error 
> and then not log any underlying hardware error on the drives the md 
> was being read from?

Is there something in mdadm --examine(-badblocks) /dev/sd*?

Regards
Andreas Klauer
