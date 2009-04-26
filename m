From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sun, 26 Apr 2009 14:14:12 +0200
Message-ID: <20090426121412.GA11921@lazy.lzy>
References: <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090424191509.GA28484@lazy.lzy> <302D7194-F25F-48B8-95E3-1A0A054A411F@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <302D7194-F25F-48B8-95E3-1A0A054A411F@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 26, 2009 at 07:52:15AM -0400, Doug Ledford wrote:
>
> I'm guessing that you didn't completely stop all usage of the hotplug  
> devices before you removed them as this works fine for me.  If the  
> devices aren't completely stopped before removal, then the stack can't  
> delete the devices.

Actually I did and *some* devices were removed.

I'm using a mdadm.conf with name and "--auto=md",
that is "name=/dev/mv/vol0" and so on.
On hot plug something happens and some devices are
created.
Then "mdadm --stop /dev/md/vol*" stops the RAIDs,
then up-plug.
The /md/dev/vol* are still there, other devices are gone.

> Removing the /dev/md/ device files does nothing of value.  However, I  

From what I saw with udevmonitor, it seems that,
with those files, there is no add event.

> will note that I've seen udev take up to 30 or 45 seconds to process a  
> bunch of md raid removals at the same time (aka, I did mdadm -S /dev/ 
> md/* and it took udev that long to remove all the old device files).   
> So, make sure you have completely stopped arrays before removing the  
> devices, then watch /dev/md/ to wait until udev does its job, then only 
> replug the array after that has happened and things should work fine.

I'll try again, I'll let you know.

bye,

-- 

piergiorgio
