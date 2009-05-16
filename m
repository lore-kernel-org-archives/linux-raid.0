From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: resync duration ?
Date: Sat, 16 May 2009 14:47:40 +1200
Message-ID: <4A0E294C.8040201@sauce.co.nz>
References: <9a9f58b3517ecbc3a076725c671f6cd1.squirrel@neil.brown.name>	<20090515050801951.MELG9927@cdptpa-omta04.mail.rr.com> <18957.58351.832772.646681@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18957.58351.832772.646681@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:

> Considered, yes.  But they are very low on my priority list.
> I accept patches.
> Maybe and option like
>    mdadm --syncaction=check /dev/md0

Perhaps it could also be incorporated in a manner similar to the way 
smartd allows for scheduled tests - a parameter added to each array in 
the mdadm.conf would allow scheduled checks when mdadm is run as a  daemon.

Regards,

Richard
