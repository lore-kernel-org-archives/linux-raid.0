From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: removed disk && md-device
Date: Fri, 11 May 2007 16:47:39 -0400
Message-ID: <4644D66B.1050706@tmr.com>
References: <200705091417.09033.bs@q-leap.de>	<20070509131450.GA31985@lapse.madduck.net>	<200705091539.53863.bs@q-leap.de>	<17986.50678.340484.891578@notabene.brown>
	<17988.2648.848008.141952@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <17988.2648.848008.141952@notabene.brown>
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
> On Thursday May 10, neilb@suse.de wrote:
>   
>> No, I haven't, but it is getting near the top of my list.
>>     
>
> I have just committed a change to the mdadm .git so that
>    mdadm /dev/md4 --fail detached
>
> will fail any components of /dev/md4 that appear to be detached (open
> returns -ENXIO). and
>    mdadm /dev/md4 --remove detached
> will remove any such devices (that are failed or spare).
> so
>
>    mdadm /dev/md4 --fail detached --remove detached
>
> will get rid of any detached devices completely, as will
>
>    mdadm /dev/md4 --fail detached --remove failed
>
> though that will also remove any failed devices that don't happen to
> be detached.

Good... but now we need a way to say "go look for any reattached parts" 
of the array, somewhat as is done at boot in most cases. Look at all 
unused devices and partitions for a superblock and UUID (or whatever).

If we had this, picture RAID1 on two drives and a USB stick. And someone 
who finger checks typing the fail before pulling the USB for the night. 
The doofus who trips over the USB cord or the power cord cord for the 
USB drive, they are all clients :-( Anything which would help recover 
from their learning experiences with removable media would be helpful.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
