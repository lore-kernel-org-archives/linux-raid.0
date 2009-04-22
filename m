From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Wed, 22 Apr 2009 16:02:30 +0200
Message-ID: <87skk0947d.fsf@frosties.localdomain>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
	<49ED096E.1000002@anonymous.org.uk>
	<49ED16F7.3040906@anonymous.org.uk>
	<4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
	<49ED2BC3.7050109@anonymous.org.uk>
	<87d4b5m4kf.fsf@frosties.localdomain>
	<49EF108D.4070605@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49EF108D.4070605@anonymous.org.uk> (John Robinson's message of
	"Wed, 22 Apr 2009 13:41:49 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson <john.robinson@anonymous.org.uk> writes:

> On 22/04/2009 10:16, Goswin von Brederlow wrote:
>> John Robinson <john.robinson@anonymous.org.uk> writes:
>>> Can't do that, my root filesystem is on the RAID-5, and part of the
>>> reason for wanting the bitmap is because the md can't be stopped while
>>> shutting down, so it was always wanting to resync at startup, which is
>>> rather tedious.
>>
>> Normal shutdown should put the raid in read-only mode as last step. At
>> least Debian does that. That way even a mounted raid will be clean
>> after reboot.
>
> Yes, I would have thought it should as well. But I've just looked at
> CentOS 5's /etc/rc.d/halt and as far as I can see it doesn't try to
> switch md devices to read-only. Of course the root filesystem has gone
> read-only but as we know that doesn't mean the device underneath it
> gets told that. In particular we know that ext3 normally opens its
> device read-write even when you're mounting the filesystem read-only
> (iirc it's so it can replay the journal).
>
> Another issue might be the LVM layer; does that need to be stopped or
> switched to read-only too?

Debian does

/sbin/vgchange -aln --ignorelockingfailure || return 2

before S60mdadm-raid, S60umountroot and S90reboot.


>> I would also suggest restructuring your system like this:
>>
>> sdX1 1GB  raid1  / (+/boot)
>> sdX2 rest raid5  lvm with /usr, /var, /home, ...
>>
>> Both / and /usr can usualy be read-only preventing any filesystem
>> corruption and raid resyncs in that part of the raid.
>
> I did do this multiple partition/LV thing once upon a time, but I got
> fed up with having to resize things when one partition was full and
> others empty. The machine is primarily a fileserver and Xen host, so
> the dom0 only has 40GB of its own, and I couldn't be bothered
> splitting that up. Having said all this, your suggestion is a good
> one, it's just my preference to have it otherwise :-)
>
> Cheers,
>
> John.

I've been using a 1GB / for years and years now so that won't be a
problem. As for the rest one can also bind mount /usr, /var, /home to
/mnt/space/* respectively. I.e. have just 2 (/ and everything else)
partitions.

Esspecially for XEN hosts I find LVM verry usefull. Makes it easy to
create new logical volumes for new xen domains.

MfG
        Goswin
