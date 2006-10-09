From: Neil Brown <neilb@suse.de>
Subject: Re: avoiding the initial resync on --create
Date: Tue, 10 Oct 2006 09:14:33 +1000
Message-ID: <17706.55257.365940.610605@cse.unsw.edu.au>
References: <20061009125700.GA10191@piper.madduck.net>
	<20061009134946.GA26122@harddisk-recovery.com>
	<1160411520.2917.76.camel@fc6.xsintricity.com>
	<37950.192.168.0.1.1160421056.squirrel@bymeinc.com>
	<1160423139.2917.112.camel@fc6.xsintricity.com>
	<17706.49180.270321.212774@cse.unsw.edu.au>
	<1160430315.2917.125.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday October 9
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Rob Bray <raid@bymeinc.com>, martin f krafft <madduck@madduck.net>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday October 9, dledford@redhat.com wrote:
> 
> superblock->init_flag == FALSE then make all writes a parity generating
> not updating write (less efficient, so you would want to resync the
> array and clear this up soon, but possible).

Yeh, that would work.  I wonder if it is worth the effort though.

> 
> Bleh...sometimes I really dislike always making things cater to the
> lowest common denominator...you're never as good as you could be and you
> are always as bad as the worst case...

damn those two-edged swords!

NeilBrown
