From: Neil Brown <neilb@suse.de>
Subject: Re: raid problem: after every reboot /dev/sdb1 is removed?
Date: Sat, 2 Feb 2008 13:32:28 +1100
Message-ID: <18339.54844.457508.84759@notabene.brown>
References: <20080201135220.617194ff@berni>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Berni on Friday February 1
Sender: linux-raid-owner@vger.kernel.org
To: Berni <wstripes@gmx.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 1, wstripes@gmx.at wrote:
> Hi!
> 
> I have the following problem with my softraid (raid 1). I'm running
> Ubuntu 7.10 64bit with kernel 2.6.22-14-generic.
> 
> After every reboot my first boot partition in md0 is not synchron. One
> of the disks (the sdb1) is removed. 
> After a resynch every partition is synching. But after a reboot the
> state is "removed". 

Please send boot logs (e.g. dmesg > afile).

NeilBrown
