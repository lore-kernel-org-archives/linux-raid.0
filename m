From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Sun, 07 Feb 2010 23:13:49 +0100
Message-ID: <4B6F3B1D.9020008@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	<1263242294-5353-3-git-send-email-dledford@redhat.com>	<20100119110930.107ca42e@notabene>	<4B55F138.7060008@redhat.com> <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6B15B3.8030205-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

Hi All,

On 02/04/2010 07:45 PM, Doug Ledford wrote:
> On 02/04/2010 01:40 AM, Neil Brown wrote:
>>

<snip>

>> Because we want to unmount and completely discard the filesystem that holds
>> the mdmon binary that was run early, we need to kill it and start a new one
>> running from final namespace.  This is also needed as to a small extent the
>> filesystem is used to communicate between mdadm and a running mdmon, and
>> having them have the same root is less confusing.
>>
>> There are three ways we can achieve this.
>>
>> 1/ If we can assume that between the time when the original "mount" completes
>>     and when the "mount -o remount,rw" happens the filesystem doesn't write to
>>     the device, then we can simply kill mdmon after the root is mounted, and
>>     restart it before remounting.   However I don't trust filesystem
>>     implementers so I won't recommend that.
>>
>> 2/ Before the pivot root we can kill the old mdmon and start the new one
>>     chrooted into the final root.
>> 3/ After the pivot root we can kill the old mdmon and start the new one.
>>
>> Number 2 is the approach that we (Well mostly Dan) originally intended and
>> that the code implements ... or tries to.  It got broken and I never
>> noticed.  I think I have fixed it now for 3.1.2.
>
> Note, as I recall, Hans switched things to be #3 for various reasons.
> That he switched it to #3 doesn't effect mdmon really, as it still is
> just killing and restarting, but doing it after the pivot root solved a
> couple issues.  I don't recall what they were, you would have to talk to
> Hans about that.
>

The reasons I made this change was that although the mdmon takeover
mechanism was designed to be used as 2., at the time I was integrating this
code in to Fedora and tying all bits together the mdmon code for doing 2
was very very broken. Back then I've send Dan a long list of issues with it,
which I believe are all fixed now.

But as using option 3. just worked from the time I integrated this and
has stayed working. I've never seen a need to switch things back to 2. again
and given that 2. requires all kind of trickery and is hard to get right,
where as 3. is pretty easy to get right, and much less prone to break
(regress) I think that staying with 3. is a good solution / decision.

As for the whole were to store mdmon .pid and .sock files, my 2cents is
that /dev is the only dir where a socket file (which cannot be moved
cross filesystems) can be made in the initramfs and still be accessible
from the real root, and other things like /lib/whythefuckputthisinslashlib/rw,
can only be implemented by:
1) adding a second tmpfs which stays living after the chroot to the real
    root.
2) symlinks which need to be both present on the real and the initramfs,
    with the big problem being ensuring they are there on the read only
    root fs from the initramds.

Both of which is needlessly complicated and fragile. So as for as I'm concerned
Fedora and the next RHEL will have these files under /dev. And if upstream
does not want this, then we will just keep patching mdadm / mdmon to do this
till the end of time. Note that /dev is already (ab)used in the same way
for passing dhcp leases from the initramfs to the running system when / lives
on a network device, and a few other state things which need to be passed
between the initramfs and the real root.

Pretty? No but effective and simple, and anytime you have this state passing
problem the most likely solution you will end up with, because it is
KISS and KISS is good.

Regards,

Hans
