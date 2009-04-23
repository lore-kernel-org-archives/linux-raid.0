From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Thu, 23 Apr 2009 08:48:10 +0100
Message-ID: <49F01D3A.8050209@anonymous.org.uk>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>	<49ED096E.1000002@anonymous.org.uk>	<49ED16F7.3040906@anonymous.org.uk>	<4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>	<49ED2BC3.7050109@anonymous.org.uk>	<87d4b5m4kf.fsf@frosties.localdomain>	<49EF108D.4070605@anonymous.org.uk> <87skk0947d.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87skk0947d.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/04/2009 15:02, Goswin von Brederlow wrote:
> John Robinson <john.robinson@anonymous.org.uk> writes:
>> Another issue might be the LVM layer; does that need to be stopped or
>> switched to read-only too?
> 
> Debian does
> 
> /sbin/vgchange -aln --ignorelockingfailure || return 2
> 
> before S60mdadm-raid, S60umountroot and S90reboot.

But that's not going to switch any VG with a still-mounted filesystem 
(e.g. /) to read-only or make it go away, it's going to fail. Still 
probably a good idea for other circumstances, though.

> I've been using a 1GB / for years and years now so that won't be a
> problem. As for the rest one can also bind mount /usr, /var, /home to
> /mnt/space/* respectively. I.e. have just 2 (/ and everything else)
> partitions.

Well, I have just 2, /boot and everything else, but I might in the 
future switch to your suggestion.

> Esspecially for XEN hosts I find LVM verry usefull. Makes it easy to
> create new logical volumes for new xen domains.

My thoughts exactly :-)

Many thanks,

John.
