From: Neil Brown <neilb@suse.de>
Subject: Re: [OT] Re: questions about softraid limitations
Date: Mon, 19 May 2008 09:52:32 +1000
Message-ID: <18480.49473.241321.362325@notabene.brown>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs>
	<482AC2BB.5010602@dgreaves.com>
	<01be01c8b61a$6e616260$9300a8c0@dcccs>
	<18476.58840.602946.872085@notabene.brown>
	<482D242B.7060908@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Rabbitson on Friday May 16
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Janos Haar <djani22@netcenter.hu>, David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 16, rabbit+list@rabbit.us wrote:
> 
> Wow, this is big :) Is it correct to state that today most of mdadm's tasks 
> can be carried out by toying with sysfs? Fascinating!

Sort-of.

Many of mdadm's tasks are "make it easy to..." or "'automatically
figure out ...".  These things cannot be done by toying in sysfs.

But yes:  most (if not all) direct manipulations of md array can be
done through text files in sysfs.

NeilBrown
