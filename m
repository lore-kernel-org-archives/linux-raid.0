From: Michal Soltys <soltys@ziu.info>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sun, 26 Apr 2009 23:37:16 +0200
Message-ID: <49F4D40C.7070003@ziu.info>
References: <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090424191509.GA28484@lazy.lzy> <302D7194-F25F-48B8-95E3-1A0A054A411F@redhat.com> <20090426121412.GA11921@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090426121412.GA11921@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Piergiorgio Sartor wrote:
> 
>> Removing the /dev/md/ device files does nothing of value.  However, I  
> 
>>From what I saw with udevmonitor, it seems that,
> with those files, there is no add event.
> 

Few remarks:

'add' uevent will happen only, if created or assembled array uses kernel 
name not yet used (in the other words, it's not present under 
/sys/block/ yet).

Actual assembly and removal cause only 'change' uevents.

Moreover - if you have partitions on the raid device, access to the 
device (usually any mdadm udev rules will trigger it due to e.g. vol_id, 
etc.) will trigger sequence of additional partition 'add' uevents.

If you issue mdadm -S, 'change' is issued for the block device, but if 
you have any md partitions on such array - 'remove' uevents for them 
will happen when another arrary (possibly the same) is created or 
assembled using the same kernel name. OR - you can for example issue 
blockdev --rereadpt /dev/md... to trigger 'remove' partition uevents 
manually and immediately.

'remove' for actual raid device will not happen. Mdadm doesn't do it 
(recalling my old discussion with Neil, it's due to some subtleties, and 
  coding it it's just not worth the effort, at least not for 2.9.x). So 
- you're left with inactive /dev node and /sys/block entry.

Still, if all your arrays and stoped, and e.g. you issue rmmod raid1 (if 
we talk about raid1 arrays for the sake of the example) - that would 
cause 'remove' uevents of course.

This is all nicely visible under udevd --debug - you might need to 
simplify your rule files in a few places to control the clobber though.

Michal


