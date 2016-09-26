From: keld@keldix.com
Subject: Re: Linux raid wiki - setting up a system - advice wanted :-)
Date: Mon, 26 Sep 2016 11:30:49 +0200
Message-ID: <20160926093049.GA1029@www5.open-std.org>
References: <57E83EA8.9060809@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57E83EA8.9060809@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Sep 25, 2016 at 10:16:24PM +0100, Wols Lists wrote:
> This is a great way for learning lots about raid :-)
> 
> I'm planning a section on setting up a new system, and I need to know
> what will happen if you give entire drives to mdadm.
> 
> Does it leave the first 2 megs empty? Basically, what I'm asking is if I do
> 
> mdadm --create /dev/md/bigarray -add /dev/sda /dev/sdb /dev/sdc
> 
> (note I am passing the entire drive, not the first partition) and then I
> install grub on those drives, will I trash the array?

There is already a section in the wiki:

https://raid.wiki.kernel.org/index.php/Preventing_against_a_failing_disk

Which should be updated for 2TB+ disks.

best regards
Keld
