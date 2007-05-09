From: Bernd Schubert <bs@q-leap.de>
Subject: removed disk && md-device
Date: Wed, 9 May 2007 14:17:08 +0200
Message-ID: <200705091417.09033.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-raid.ids

Hi,

we are presently running into a hotplug/linux-raid problem.

Lets assume a hard disk entirely fails or a stupid human being pulls it out of 
the system. Several partitions of the very same hardisk are also part of 
linux-software raid. Also, /dev is managed by udev.

Problem-1) When the disk fails, udev will remove it from /dev. Unfortunately 
this will make it impossible to remove the disk or its partitions 
from /dev/mdX device, since mdadm tries to read the device fail and will 
abort if this file is not there.

Problem-2) Even though the kernel detected the device to not exist anymore, it 
didn't inform its md-layer about this event. The md-layer will first detect 
non-existent disk, if a read or write attempt to one of its raid-partitions 
fails. Unfortunately, if you are unluckily, it might never detect that, e.g. 
for raid1 devices.

I think there should be several solutions to these problems.

1) Before udev removes a device file, it should run a pre-remove script, which 
should check if the device is listed in /proc/mdstat and if it is listed 
there, it should run mdadm to remove this device from the.
Does udev presently support to run pre-remove scripts?

2.) As soon as the kernel detects a failed device, it should also inform the 
md layer.

3.) Does mdadm really need the device?


Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
