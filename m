From: John McNulty <johnmcn1@googlemail.com>
Subject: Re: What will happen with spares in this scenario?
Date: Mon, 29 Jun 2009 22:07:57 +0100
Message-ID: <9A9AF670-B7EF-4E91-984D-445374CEFA82@googlemail.com>
References: <ab50889f0906290828s44e10b14n1af6d23556e3f0ee@mail.gmail.com> <87zlbruinb.fsf@frosties.localdomain>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zlbruinb.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29 Jun 2009, at 17:08, Goswin von Brederlow wrote:

> So drop md1, make c0d0p1 as big as the others and then partition
> md0 eigther directly or via lvm.

You wouldn't happen to know if it's possible to create a partitionable  
array like this in Kickstart would you?   I've had a sniff around  
Redhat's docs and a documented way of doing this isn't jumping out at  
me.    If I had to guess then it might look something like this?

part  pv.1  --size 1 --ondisk cciss/c0d0 --grow --asprimary
part  pv.2  --size 1 --ondisk cciss/c1d0 --grow --asprimary
raid  pv.3  --level=RAID1 --device=md_d0 pv.1 pv.2
part /boot --fstype ext3 --size 300 --ondisk md_d0
part pv.4 --fstype "physical volume (LVM) --size 1 --ondisk md_d0 --grow
volgroup system --pesize=32768 pv.4
logvol / --fstype ext3 --name=root --vgname=system --size=51200
logvol swap --fstype swap --name=swap --vgname=system --size=8192

This might be a bit ambitious, and I can't see an option to "raid"  
that would tell it to create a partitionable raid device, i.e. run -- 
auto=mdp behind the scenes.   Unless it takes a hint from the device  
name and does that without asking?

The systems I'm working on are to be kickstarted from a Spacewalk  
server.

Rgds,

John

