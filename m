From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Thu, 23 Apr 2009 22:23:54 +0200
Message-ID: <878wlrw23p.fsf@frosties.localdomain>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
	<49ED096E.1000002@anonymous.org.uk>
	<49ED16F7.3040906@anonymous.org.uk>
	<4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
	<49ED2BC3.7050109@anonymous.org.uk>
	<87d4b5m4kf.fsf@frosties.localdomain>
	<49EF108D.4070605@anonymous.org.uk>
	<20090422142148.GC13280@skl-net.de>
	<49F0211C.3010306@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F0211C.3010306@anonymous.org.uk> (John Robinson's message of
	"Thu, 23 Apr 2009 09:04:44 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Goswin von Brederlow <goswin-v-b@web.de>
List-Id: linux-raid.ids

John Robinson <john.robinson@anonymous.org.uk> writes:

> On 22/04/2009 15:21, Andre Noll wrote:
>> On 13:41, John Robinson wrote:
>>>> Normal shutdown should put the raid in read-only mode as last step. At
>>>> least Debian does that. That way even a mounted raid will be clean
>>>> after reboot.
>>> Yes, I would have thought it should as well. But I've just looked
>>> at CentOS 5's /etc/rc.d/halt and as far as I can see it doesn't try
>>> to switch md devices to read-only.
>>
>> There's no need to do that in the shutdown script as the kernel will
>> switch all arrays to read-only mode on halt/reboot.
>>
>> Moreover, as raid arrays are automatically marked clean if no writes
>> are pending for some small time period, a simple "sync; sleep 1"
>> at the end of the shutdown script is usually enough to have a clean
>> array during the next boot.
>
> But that's still only "usually". Considering the enormous efforts
> taken to unmount filesystems (or remount them read-only) so they're
> certain to be clean at the next startup, it seems odd to settle for
> "usually"... and CentOS 5 doesn't even appear to do that.
>
> Goswin, please can you tell me what command Debian uses? I think I
> want to combine both of these into my systems' halt scripts.
>
> Cheers,
>
> John.

On halt I do see a message about the raid being switched to read-only
but I don't see any command that would do that. So I do believe this
is, as Andre says, the kernel switching the raid read-only before
halting.

Maybe your kernel is too old to have this feature?

MfG
        Goswin
