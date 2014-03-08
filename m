From: Martin T <m4rtntns@gmail.com>
Subject: Re: Is mdadm.conf needed?
Date: Sat, 8 Mar 2014 03:07:26 +0000
Message-ID: <CAJx5YvH3AqY8jcw-U7hGSeXe55xTPLxdi6zsKVLM9pUBRwAocw@mail.gmail.com>
References: <CAJx5YvG5sA9GcPEd2D59ekg+QrRj7YGTKW=a8MMmLUWwkMo8fA@mail.gmail.com>
	<B13575D2-B437-4C38-9A31-E58CCE72F189@colorremedies.com>
	<531A2883.1000100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <531A2883.1000100@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>, pg@lxra2.for.sabi.co.uk, lists@colorremedies.com
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for explaining this!



regards,
Martin

On Fri, Mar 7, 2014 at 8:13 PM, Joe Landman <joe.landman@gmail.com> wrote:
> On 03/07/2014 03:00 PM, Chris Murphy wrote:
>>
>>
>> On Mar 6, 2014, at 7:13 PM, Martin T <m4rtntns@gmail.com> wrote:
>>
>>> Hi,
>>>
>>> while most of the Linux software-RAID related tutorials suggest to
>>> have the mdadm.conf file up to date, then is it actually needed or
>>> used any more? I mean all the data needed by kernel for creating
>>> the RAID arrays should be stored in the superblocks, shouldn't it?
>>> Or in which situation the mdadm.conf is needed?
>>
>>
>> Good question. mdadm.conf is baked into the initramfs by dracut,
>> along with mdadm, on Fedora systems. I haven't tried to willfully
>> break it by deleting mdadm.conf and rebuilding the initramfs to see
>> if it still works.
>
>
> On diskless systems, I have as part of the startup, an
>
>         mdadm --examine --scan > /tmp/mdadm.scanned.conf
>         mdadm -As --conf=/tmp/mdadm.scanned.conf
>
> so technically its not needed a-priori here.  For systems with the root on a
> particular RAID you would want to assemble the RAID before the switch.  Most
> dracut based systems complain quite vociferously when you make mdadm go
> away, as they don't seem able to do what we've done above to figure out what
> they should assemble.
>
>
>> I'm pretty sure it happens within the initramfs prior to the kernel
>> even attempting to mount root. On systemd systems this could be
>> better learned by passing systemd.log_level=debug
>> systemd.log_target=console. The initramfs contains systemd, mdadm,
>> mdadm.conf - and I'm pretty sure systemd activates that service, and
>> then mdadm uses the mdadm.conf that's in the initramfs to assemble
>> the array, and then systemd mounts it per the kernel command line
>> which specifies root as an mduuid.
>
>
> It would be nice if, as part of the startup, it did a scan, a comparison of
> the root device to whats available, and instead of timing out or panicing
> (both of which I've seen), that it  drops into a shell if the root raid
> device is either a) not there, or b) not ok to assemble.  The rd.shell
> dracut line sorta/kinda does this.  I am not sure what the systemd
> equivalent is.
>
> Basically what I am saying is that the metadata for assembling the RAIDs is
> on the disks themselves, and the mdadm.conf (if it exists) should be used
> for confirmation/security/warning/error reporting purposes ... and not
> necessarily for actual assembly.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
