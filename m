From: Colin McCabe <Colin.P.McCabe@gmail.com>
Subject: Re: removed disk && md-device
Date: Wed, 16 May 2007 17:19:44 -0400
Message-ID: <464B7570.2070809@gmail.com>
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
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net
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

Keeping admins in the dark about hotplug is a misfeature.

If you look at /proc/mdstat and you see 4 devices, but actually the 
janitor unplugged them all yesterday, you are just going to be more 
confused when things eventually fail, not less. It's a like a fuel gauge 
that says "full," but actually there's only a few drops left in the tank.

> Suppose I have two USB drives with a mounted but quiescent filesystem
> on a raid1 across them.
> I pull them both out, one after the other, to take them to my friends
> place.
> 
> I plug them both in and find that the array is degraded, because as
> soon as I unplugged on, the other was told that it was now the only
> one. 

Filesystems have mount / umount; RAID has mdadm --assemble / mdadm 
--stop. If you start pulling disks without doing the necessary cleanup, 
you should EXPECT the array to go into a degraded state.

Colin


> Not good.  Best to wait for an IO request that actually returns an
> errors. 
> 
>>> Maybe an mdadm command that will do that for a given device, or for
>>> all components of a given array if the 'dev' link is 'broken', or even
>>> for all devices for all array.
>>>   mdadm --fail-unplugged --scan
>>> or
>>>   mdadm --fail-unplugged /dev/md3
>> Ok, so one could run this as cron script. Neil, may I ask if you already 
>> started to work on this? Since we have the problem on a customer system, we 
>> should fix it ASAP, but at least within the next 2 or 3 weeks. If you didn't 
>> start work on it yet, I will do...
> 
> No, I haven't, but it is getting near the top of my list.
> If you want a script that does this automatically for every array,
> something like:
> 
>   for a in /sys/block/md*/md/dev-*
>   do
>     if [ -f $a/block/dev ]
>     then : still there
>     else
> 	echo faulty > $a/state
> 	echo remove > $a/state
>     fi
>   done
> 
> should do what you want. (I haven't tested it though).
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
