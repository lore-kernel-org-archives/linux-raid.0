From: Neil Brown <neilb@suse.de>
Subject: Re: 2.4 and --grow?
Date: Fri, 14 Oct 2005 13:43:50 +1000
Message-ID: <17231.10614.220931.197105@cse.unsw.edu.au>
References: <61204.60.234.162.14.1129259597.squirrel@mail.react.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carl Jones on Friday October 14
Sender: linux-raid-owner@vger.kernel.org
To: Carl Jones <lists@outervoid.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 14, lists@outervoid.net wrote:
> I want to make the spare device active. I'm using:
> 
> ./mdadm --grow /dev/md0 --raid-disks=2
> 
> I'm using mdadm 1.9.0 (compiled from source). Kernel is 2.4.21-15.0.3.EL.
> 
> Am I using the proper command line options? 

Yes.

> Will I need a 2.6 kernel?

Yes.

NeilBrown
