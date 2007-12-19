From: Iustin Pop <iusty@k1024.org>
Subject: Re: help diagnosing bad disk
Date: Wed, 19 Dec 2007 22:45:00 +0100
Message-ID: <20071219214500.GA9819@teal.hq.k1024.org>
References: <fa2952810712191018l76085e90l4eb2c6a81115fa1f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fa2952810712191018l76085e90l4eb2c6a81115fa1f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Sabo <jonathan.sabo@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 19, 2007 at 01:18:21PM -0500, Jon Sabo wrote:
> So I was trying to copy over some Indiana Jones wav files and it
> wasn't going my way.  I noticed that my software raid device showed:
> 
> /dev/md1 on / type ext3 (rw,errors=remount-ro)
> 
> Is this saying that it was remounted, read only because it found a
> problem with the md1 meta device?  That's what it looks like it's
> saying but I can still write to /.

FYI, it means that it is currently "rw", and if there are errors, it
will remount the filesystem readonly (as opposed to panic-ing).

regards,
iustin
