From: Neil Brown <neilb@suse.de>
Subject: Re: issue with internal bitmaps
Date: Fri, 7 Jul 2006 08:16:18 +1000
Message-ID: <17581.35762.452409.927246@cse.unsw.edu.au>
References: <20060706141207.GC21642@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Thursday July 6
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 6, bluca@comedia.it wrote:
> hello, i just realized that internal bitmaps do not seem to work
> anymore.

I cannot imagine why.  Nothing you have listed show anything wrong
with md...

Maybe you were expecting
   mdadm -X /dev/md100
to do something useful.  Like -E, -X must be applied to a component
device.  Try
   mdadm -X /dev/sda1

Patch to documentation are always welcome :-)

NeilBrown
