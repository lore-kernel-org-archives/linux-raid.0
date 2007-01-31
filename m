From: Sean Puttergill <puttergi@yahoo.ca>
Subject: Hot add not supported by version 1.x superblocks?
Date: Wed, 31 Jan 2007 10:58:23 -0800 (PST)
Message-ID: <218044.89383.qm@web34405.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil.

I have a RAID1 built using v1.2 superblocks.  I seem to not be able to hot add a spare drive to this array.
I get the error message:

"HOT_ADD may only be used with version-0 superblocks"

Does this really mean that hot add is not supported for arrays built with v1.x superblocks?
If so this seems like a big regression in functionality.  In this case, are there technical reasons why v1.x cannot support hot add?

I am using a stock 2.6.18 kernel with mdadm v2.5.4


Thanks,
Sean




__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
