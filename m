From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Adding disks with raid to existing raid system.
Date: Mon, 15 Mar 2010 22:31:10 -0700
Message-ID: <40b437201003152231j78494657la373a2ab67156cbe@mail.gmail.com>
References: <40b437201003142323g7b0f4e48wb9d58b963f12e988@mail.gmail.com>
	 <4877c76c1003151836r56d03faeh50d8bfd1bb2925cf@mail.gmail.com>
	 <40b437201003152053i69fd7a69kfa25f2900a01bb6f@mail.gmail.com>
	 <4877c76c1003152159o315f0a64mcbf0203170010c26@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003152159o315f0a64mcbf0203170010c26@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 15, 2010 at 9:59 PM, Michael Evans <mjevans1983@gmail.com> =
wrote:
> On Mon, Mar 15, 2010 at 7:53 PM, Simon Matthews
> <simon.d.matthews@gmail.com> wrote:
>> On Mon, Mar 15, 2010 at 5:36 PM, Michael Evans <mjevans1983@gmail.co=
m> wrote:
>>> On Sun, Mar 14, 2010 at 10:23 PM, Simon Matthews
>>> <simon.d.matthews@gmail.com> wrote:
>>>> I have just built a system and have it booting off a software raid
>>>> partition. The raid sets use devices /dev/md0, /dev/hd1, /dev/md2,
>>>> /dev/md3.
>>>>
>>>> I now need to transfer some additional disks to this system. These
>>>> disks are presently in another system where they host a number of =
raid
>>>> sets, currently also /dev/md0 - /dev/md4.
>>>>
>>>> I need to ensure that the data on the raid set that I am adding to=
 the
>>>> system is not lost. However, clearly, I can't have the raid sets o=
n
>>>> these disks come up as /dev/md0-md4. How do I ensure this and have
>>>> these raid sets come up on /dev/md5 and higher?
>>>>
>>>> Simon
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>> Either use an mdadm.conf to specify the mapping of UUID to md devic=
e
>>> (which will over-ride any auto-detected requests), or use the
>>> home-host fallback. =A0Obviously the administrator specifying how t=
hey'd
>>> prefer mdadm to assemble the drives is preferable.
>>
>> I'm not aware of the "home-host fallback" can you give me some point=
ers on this?
>>>
>>> You will probably want to regenerate your initrd; if you are using
>>> auto-assembly on root without an initrd, I highly suggest upgrading=
 to
>>> use an initrd/initramfs. =A0You might find this one easy to customi=
ze
>>> for your needs if your distribution lacks one or you dislike the on=
e
>>> it generates: http://sourceforge.net/projects/aeuio/
>>
>> Fortunately Gentoo includes mkinitrd so I can try this if other
>> methods don't work reliably.
>>
>> Simon
>>
>>>
>>
>
> man mdadm
> /host
>
> --homehost=3D
>
> This will override any HOMEHOST setting in the config file and
> provides the identity of the host which should be considered the home
> for any arrays.
>
> ... etc
>
> Before asking any further questions I highly suggest reading the
> manual, completely, at least twice.
>

In my defense, I did try to google this, but I looked for "home-host"
or "home host" and nothing turned up. Many thanks for your help. I
think this will solve my question about added existing arrays to a
system.

Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
