From: Felipe Sateler <fsateler@debian.org>
Subject: Re: mdadm: Has init script in runlevel S but no matching service file
Date: Thu, 31 Mar 2016 16:43:06 -0300
Message-ID: <CAAfdZj85B3iNAVDVMqj85xqpGtUhajG0j2RHOWbEVBPo49koNQ@mail.gmail.com>
References: <CAAfdZj_hDJOS2-Q9BchbnBhsprUOn_EmftGLXR-t_b7BOidUYw@mail.gmail.com>
 <CAAfdZj8eoXxr_fU8OU+G2S1s4RnJrTB7fAtLxwwtsjeN+BXj=g@mail.gmail.com> <wrfjegaq8nry.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjegaq8nry.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: 796624@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On 31 March 2016 at 16:12, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Felipe Sateler <fsateler@debian.org> writes:
>> Hello upstream mdadm.
>>
>> I'm adding you to CC to resolve the issue of an init script that
>> current debian uses, that might possibly be redundant. Please see my
>> below diagnosis
>>
>> On 24 December 2015 at 16:10, Felipe Sateler <fsateler@debian.org> wrote:
>>>
>>> On Sat, 22 Aug 2015 22:32:00 -0300 fsateler@debian.org wrote:
>>> > Hi,
>>> >
>>> > Your package mdadm has an initscript that is enabled in runlevel S,
>>> > but it does not provide a corresponding systemd service unit.
>>>
>>> It seems that the mdadm-raid init script (which triggered this bug
>>> report) is not useful on a udev system (which all systemd systems
>>> are[1]). The file /lib/udev/rules.d/64-md-raid-assembly.rules assembles
>>> the arrays incrementally as devices are known to udev, and so running
>>> a separate assembly step should be superfluous. If this is not true,
>>> then maybe this should be reported upstream, as there is a systemd
>>> service missing.
>>
>> For reference, the init script in question can be seen in the souces
>> site[1]. On boot, it invokes mdadm --assemble and reports some status
>> messages for each md device.
>>
>> So, the questions are: is this init script redundant on a udev system?
>> If not, isn't an equivalent systemd unit missing upstream?
>
> I haven't looked at Debian's scripts here, but whatever Debian uses as
> init scripts to control mdadm startup is decided by the Debian mdadm
> maintainer. We do carry a set of system files for mdadm in the
> mdadm/systemd directory, so if something is missing, it may be that the
> Debian maintainer forgot to include it.

I may have been a bit unclear, and omitted important information. The
systemd units are in fact shipped by mdadm:

mdadm: /lib/systemd/system-shutdown/mdadm.shutdown
mdadm: /lib/systemd/system/mdadm-grow-continue@.service
mdadm: /lib/systemd/system/mdadm-last-resort@.service
mdadm: /lib/systemd/system/mdadm-last-resort@.timer
mdadm: /lib/systemd/system/mdadm-waitidle.service
mdadm: /lib/systemd/system/mdadm.service
mdadm: /lib/systemd/system/mdmon@.service
mdadm: /lib/systemd/system/mdmonitor.service


mdadm.service and mdadm-waitidle.service are symlinks to /dev/null, to
mask the (debian-specific) sysv init scripts. However, there is still
one init script left that is not masked. This init script calls mdadm
--assemble --scan --auto=yes --symlink=no (and a bit more, full script
linked in the original message). None of the upstream units invoke
mdadm --assemble, probably because the udev rules assemble the arrays
incrementally via mdadm --incremental.

....

But now that I reviewed the rules file again, I find that the rules
are modified in debian to disable the incremental assembly. So, the
script would still be needed, but due to a deviation from upstream.

This discussion should then continue on the debian bug report only.

Thanks and sorry for the noise.

-- 

Saludos,
Felipe Sateler
