From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid1 and swap
Date: Mon, 7 Apr 2003 19:41:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16017.18373.493423.709500@notabene.cse.unsw.edu.au>
References: <3.0.6.32.20030407105058.00b7ca30@athen>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alfred Isele on Monday April 7
To: Alfred Isele <Alfred.Isele@fujitsu-siemens.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 7, Alfred.Isele@fujitsu-siemens.com wrote:
> 
> Hello!
> I have a question concerning the use of raid1 (md) 
> together with swap. I use this /etc/fstab entry:
> 
> /dev/md1   none  swap  pri=42  0 0
> 
> Somebody told me swap could be damaged if 
> one of the mirrored devices used for swap fails and 
> a spare disk is resynched for it because the resync would 
> be done using the buffer cache whereas the swapping would
> be done by direct disk access. 
> Do you know if such a problem exists?

In 2.2 kernels, yes.
In 2.4.0 and later, no.

NeilBrown
