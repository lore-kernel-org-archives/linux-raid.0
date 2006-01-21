From: Neil Brown <neilb@suse.de>
Subject: Re: linear raid space utilization
Date: Sat, 21 Jan 2006 21:39:34 +1100
Message-ID: <17362.3942.564339.163980@cse.unsw.edu.au>
References: <cc5782160601202312y25bc339cvcb1973c24208da3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andy Gajetzki on Saturday January 21
Sender: linux-raid-owner@vger.kernel.org
To: Andy Gajetzki <andy.gajetzki@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday January 21, andy.gajetzki@gmail.com wrote:
> Hi there,  I recently had a disk go bad in a linear RAID built with
> mdadm. The particular disk that failed was the last  device of the
> RAID. I am curious about how  devices are utilized in a linear RAID.
> Would the md be filled sequentially from device 1 upto 5? In other
> words, what are the odds that the last disk was "empty" when it went
> south?

How the space is used depends on the filesystem you had created on the
device.

Many filesystems tend to spread data out so there is plenty of room to
insert new data 'close' to related data.
So if your filesystem was more than about 10% full, there if a very
good chance that a significant fraction was in that last device, and
even if it was less full than that,  their is at least a fair chance
that you have lost a reasonable amount of data.

NeilBrown
