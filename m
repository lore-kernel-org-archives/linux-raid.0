From: David Greaves <david@dgreaves.com>
Subject: Re: removed disk && md-device
Date: Thu, 10 May 2007 15:33:47 +0100
Message-ID: <46432D4B.4010302@dgreaves.com>
References: <200705091417.09033.bs@q-leap.de>	<20070509131450.GA31985@lapse.madduck.net>	<200705091539.53863.bs@q-leap.de>
	<17986.50678.340484.891578@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <17986.50678.340484.891578@notabene.brown>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, 416512@bugs.debian.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday May 9, bs@q-leap.de wrote:
>> Neil Brown <neilb@suse.de> [2007.04.02.0953 +0200]:
>>> Hmmm... this is somewhat awkward.  You could argue that udev should be
>>> taught to remove the device from the array before removing the device
>> >from /dev.  But I'm not convinced that you always want to 'fail' the
>>> device.   It is possible in this case that the array is quiescent and
>>> you might like to shut it down without registering a device failure...
>> Hmm, the the kernel advised hotplug to remove the device from /dev, but you 
>> don't want to remove it from md? Do you have an example for that case?
> 
> Until there is known to be an inconsistency among the devices in an
> array, you don't want to record that there is.
> 
> Suppose I have two USB drives with a mounted but quiescent filesystem
> on a raid1 across them.
> I pull them both out, one after the other, to take them to my friends
> place.
> 
> I plug them both in and find that the array is degraded, because as
> soon as I unplugged on, the other was told that it was now the only
> one.
And, in truth, so it was.

Who updated the event count though?

> Not good.  Best to wait for an IO request that actually returns an
> errors. 
Ah, now would that be a good time to update the event count?


Maybe you should allow drives to be removed even if they aren't faulty or spare?
A write to a removed device would mark it faulty in the other devices without
waiting for a timeout.

But joggling a usb stick (similar to your use case) would probably be OK since
it would be hot-removed and then hot-added.

David

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
