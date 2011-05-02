From: David Brown <david@westcontrol.com>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 11:11:25 +0200
Message-ID: <4DBE753D.20709@westcontrol.com>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net> <1304051980.3105.46.camel@localhost> <8739kyf53e.fsf@servo.factory.finestructure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8739kyf53e.fsf@servo.factory.finestructure.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>, 624343@bugs.debian.org, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/2011 00:06, Jameson Graef Rollins wrote:
> On Fri, 29 Apr 2011 05:39:40 +0100, Ben Hutchings<ben@decadent.org.uk>  wrote:
>> On Wed, 2011-04-27 at 09:19 -0700, Jameson Graef Rollins wrote:
>>> I run what I imagine is a fairly unusual disk setup on my laptop,
>>> consisting of:
>>>
>>>    ssd ->  raid1 ->  dm-crypt ->  lvm ->  ext4
>>>
>>> I use the raid1 as a backup.  The raid1 operates normally in degraded
>>> mode.  For backups I then hot-add a usb hdd, let the raid1 sync, and
>>> then fail/remove the external hdd.

This is not directly related to your issues here, but it is possible to 
make a 1-disk raid1 set so that you are not normally degraded.  When you 
want to do the backup, you can grow the raid1 set with the usb disk, 
want for the resync, then fail it and remove it, then "grow" the raid1 
back to 1 disk.  That way you don't feel you are always living in a 
degraded state.


