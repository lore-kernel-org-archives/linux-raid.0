From: Bernd Schubert <bs@q-leap.de>
Subject: Re: removed disk && md-device
Date: Wed, 9 May 2007 15:39:53 +0200
Message-ID: <200705091539.53863.bs@q-leap.de>
References: <200705091417.09033.bs@q-leap.de> <20070509131450.GA31985@lapse.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070509131450.GA31985@lapse.madduck.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, 416512@bugs.debian.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Wednesday 09 May 2007 15:14:50 martin f krafft wrote:
> also sprach Bernd Schubert <bs@q-leap.de> [2007.05.09.1417 +0200]:
> > Problem-1) When the disk fails, udev will remove it from /dev.
> > Unfortunately this will make it impossible to remove the disk or its
> > partitions from /dev/mdX device, since mdadm tries to read the device
> > fail and will abort if this file is not there.
>
> Please also see http://bugs.debian.org/416512. It would be nice if
> you could keep 416512@bugs.debian.org on CC.
>
> mdadm upstream knows of the problem. See the bug log.

Ah, so Goswin already wrote a bug report :) Actually Goswin first did run into 
this problem here while doing some internal tests, but today we have it on a 
customer system.

Neil Brown <neilb@suse.de> [2007.04.02.0953 +0200]:
>Hmmm... this is somewhat awkward.  You could argue that udev should be
>taught to remove the device from the array before removing the device
>from /dev.  But I'm not convinced that you always want to 'fail' the
>device.   It is possible in this case that the array is quiescent and
>you might like to shut it down without registering a device failure...

Hmm, the the kernel advised hotplug to remove the device from /dev, but you 
don't want to remove it from md? Do you have an example for that case?

>It is still possible to fail and remove the device by
>writing "faulty" and then "remove" to
>  /sys/block/mdX/md/dev-YYY/state

>Maybe an mdadm command that will do that for a given device, or for
>all components of a given array if the 'dev' link is 'broken', or even
>for all devices for all array.

>   mdadm --fail-unplugged --scan
>or
>   mdadm --fail-unplugged /dev/md3

Ok, so one could run this as cron script. Neil, may I ask if you already 
started to work on this? Since we have the problem on a customer system, we 
should fix it ASAP, but at least within the next 2 or 3 weeks. If you didn't 
start work on it yet, I will do...


Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
