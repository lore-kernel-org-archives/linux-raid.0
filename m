From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID without superblock
Date: Mon, 20 Apr 2009 00:33:08 +0100
Message-ID: <49EBB4B4.40102@anonymous.org.uk>
References: <20090419114743.GA29195@lazy.lzy> <e96b335a0ba8595e2921d164f9b15ff7.squirrel@neil.brown.name> <20090419210200.GA6942@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090419210200.GA6942@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/04/2009 22:04, Piergiorgio Sartor wrote:
>> Why would you want a RAID-1 without superblock. I generally
>> consider that a legacy configuration.
> 
> Ah! I was thinking about it as a method to
> build a RAID with an already existing disk
> or partition, which cannot be modified.

Well, something somewhere is going to have to change; at the very least 
you're going to have to stop whatever's using the filesystem, unmount 
it, do whatever to create the new RAID-1 incorporating the original 
disc, and remount the filesystem now on the new md device.

So instead you could create a new RAID-1 md device with (a superblock 
and) one disc missing, create a filesystem on it, stop your original 
filesystem, copy its contents to the new md device, mount it, and add 
the original disc into the new md device.

If you've too much data to be able to afford the downtime copying, use 
rsync with the appropriate options while the filesystem's still in use, 
then again after it's been stopped; the second copy will complete far 
faster than the full copy.

Cheers,

John.

