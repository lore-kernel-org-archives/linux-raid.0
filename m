From: Shaun Jackman <sjackman@gmail.com>
Subject: Re: Migrating from non-RAID to RAID-1
Date: Tue, 9 Aug 2005 18:42:57 -0700
Message-ID: <7f45d9390508091842473da782@mail.gmail.com>
References: <7f45d93905080916414e291a87@mail.gmail.com>
	 <42F93FB5.1040901@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42F93FB5.1040901@h3c.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2005/8/9, Mike Hardy <mhardy@h3c.com>:
> This was asked not but a few days ago. While not intending to be rude, I
> believe searching the archives will turn up step by step guidance
> 
> -Mike

Thanks for the pointer, Mike. I was using Google's mailing list
archive, but it seems woefully incomplete.
http://groups.google.ca/group/mlist.linux.raid

Another linux-raid archive had the message you mentioned:
http://marc.theaimsgroup.com/?l=linux-raid&m=112318177226599

The directions were...
sfdisk -d /dev/sda > /tmp/sda.part
sfdisk /dev/sdb < /tmp/sda.part
read the Software RAID-HowTo, and look for the Root-RAID section

Cheers,
Shaun
