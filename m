From: Harald Hoyer <harald@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Wed, 10 Feb 2010 10:46:50 +0100
Message-ID: <4B72808A.60208@redhat.com>
References: <1263242294-5353-3-git-send-email-dledford@redhat.com>	<20100119110930.107ca42e@notabene>	<4B55F138.7060008@redhat.com>	<20100204174009.6072ec07@notabene.brown>	<4B6B15B3.8030205@redhat.com>	<e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>	<4B6DAC06.6060909@redhat.com>	<e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>	<4B702EA5.3030103@redhat.com>	<20100209083838.6568cac0@notabene.brown>	<20100209021949.GB11780@lapse.rw.madduck.net>	<4B71C6CA.3010407@redhat.com>	<alpine.LNX.2.01.1002091553580.10004@filesrv1.baby-dragons.com> <20100210123321.324e5de6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100210123321.324e5de6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, linux-raid maillist <linux-raid@vger.kernel.org>, initramfs@vger.kernel.org, Michal Marek <mmarek@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bill Nottingham <notting@redhat.com>
List-Id: linux-raid.ids

On 02/10/2010 02:33 AM, Neil Brown wrote:
> One idea that has occurred to me is that maybe /sys is the right place to put
> this stuff!!!  If only sysfs directories could be writeable, I could write the
> pid file in /sys/class/block/md0/md/mdmon.pid and create a socket with a
> similar name.

Another idea might also be /dev/shm/ which is also writable..
