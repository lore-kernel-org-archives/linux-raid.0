From: Neil Brown <neilb@suse.de>
Subject: Re: md array numbering is messed up
Date: Tue, 31 Oct 2006 14:06:27 +1100
Message-ID: <17734.48563.659660.147905@cse.unsw.edu.au>
References: <45451A4C.9010708@peeble.net>
	<17733.7315.357603.311275@cse.unsw.edu.au>
	<4545DECE.7030705@tls.msk.ru>
	<45468FA9.4010303@peeble.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peb on Tuesday October 31
Sender: linux-raid-owner@vger.kernel.org
To: Peb <peb-misc@peeble.net>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, dean@arctic.org, brad@wasp.net.au
List-Id: linux-raid.ids

On Tuesday October 31, peb-misc@peeble.net wrote:
> 
> Well I have the following mdadm.conf:
> 
> DEVICE /dev/hda /dev/hdc /dev/sd*
> ARRAY /dev/md1 level=raid5 num-devices=4 UID=8ed64073:04d21e1c:33660158:
> a5bc892f
> ARRAY /dev/md0 level=raid1 num-devices=2 UID=cab9de58:d20bffae:654d1910:
> 6f440136
> 
> I 've tried inverting the two ARRAY lines and placing the sd* device
> before the ide drives, but that didn't change anything.
> 
> So I guess my mdadm.conf isn't correct since mdrun is still running even
> though the file exists ???

Try 
   sh -x /etc/init.d/mdadm-raid start
and see what it does.
If have created /etc/mdadm/mdadm.conf rather than /etc/mdadm.conf have
you?  Debian decided the config file should be in a directory
/etc/mdadm, and so are different from everyone else...

NeilBrown
