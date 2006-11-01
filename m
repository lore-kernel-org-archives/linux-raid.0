From: Peb <peb-misc@peeble.net>
Subject: Re: md array numbering is messed up
Date: Wed, 01 Nov 2006 21:20:45 +0100
Message-ID: <4549019D.9080107@peeble.net>
References: <45451A4C.9010708@peeble.net>
 <17733.7315.357603.311275@cse.unsw.edu.au> <4545DECE.7030705@tls.msk.ru>
 <45468FA9.4010303@peeble.net> <17734.48563.659660.147905@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <17734.48563.659660.147905@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, dean@arctic.org, brad@wasp.net.au
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 31, peb-misc@peeble.net wrote:
>> Well I have the following mdadm.conf:
>>
>> DEVICE /dev/hda /dev/hdc /dev/sd*
>> ARRAY /dev/md1 level=raid5 num-devices=4 UID=8ed64073:04d21e1c:33660158:
>> a5bc892f
>> ARRAY /dev/md0 level=raid1 num-devices=2 UID=cab9de58:d20bffae:654d1910:
>> 6f440136
>>
> Try 
>    sh -x /etc/init.d/mdadm-raid start
> and see what it does.
> If have created /etc/mdadm/mdadm.conf rather than /etc/mdadm.conf have
> you?  Debian decided the config file should be in a directory
> /etc/mdadm, and so are different from everyone else...
> 
> NeilBrown

Neil,
I ran the sh -x /etc/init.d/mdadm-raid start command and it is starting
the arrays through mdadm -A -s and not by running mdrun.

All in all, I'd tried the following before checking mdadm-raid:
removing /sbin/mdrun
removing my mdadm.conf
placing my mdadm.conf in /etc instead of /etc/mdadm/

It just seems to be linked to the kernel.. since when booting from
2.6.12 my initscripts and config just work, while when using 2.6.15
without changing anything else.

--
Peb
