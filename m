From: Ian Pilcher <pilchman@attbi.com>
Subject: Re: Safest way to renumber RAID-5 devices
Date: Sat, 28 Jun 2003 04:13:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EFD5C56.5080109@attbi.com>
References: <3EFD4BBF.1020405@attbi.com> <16125.20826.76778.935888@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16125.20826.76778.935888@gargle.gargle.HOWL>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> mdadm -A --update=superminor /dev/mdNEWNUMBER  /dev/sd...
> 
> should work with mdadm 1.2.0.
> 

Works like a charm.  I didn't realize that Red Hat was shipping a
back level version (in addition to still using the old raidtools in
their init scripts).

> 
> Check the manpage to make sure I haven't mispelled somthing.
> 

You forgot the hyphen in super-minor.  :-)

Thanks!
-- 
========================================================================
Ian Pilcher                                           pilchman@attbi.com
========================================================================

