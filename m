From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Raid Q
Date: Mon, 11 Aug 2003 21:43:27 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F38463F.9C849738@SteelEye.com>
References: <MPEEJJCBBFOCGLEOCJNAGENKDKAA.admin@sscrmnl.edu.ph>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Jose Nathaniel G. Nengasca" <admin@sscrmnl.edu.ph>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Jose Nathaniel G. Nengasca" wrote:
> 
> I just created RAID1, and now its running smoothly... Now how can I add raid
> device to fstab? coz i always type 'mkraid' during restart and to solve this
> i added it on /etc/rc.d/rc.local.. so i guess fstab is the answer, so that i
> dont use /etc/rc.d/rc.local or run mkraid manually everytime it start...

It probably depends on which distribution you're running, but on Red Hat
or SuSE you just need to add an entry to /etc/raidtab for your raid1
device (man raidtab for details) and if you also want to mount the
device at boot time, add an entry to /etc/fstab too.

--
Paul
