From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Adding disks with raid to existing raid system.
Date: Mon, 15 Mar 2010 19:53:55 -0800
Message-ID: <40b437201003152053i69fd7a69kfa25f2900a01bb6f@mail.gmail.com>
References: <40b437201003142323g7b0f4e48wb9d58b963f12e988@mail.gmail.com>
	 <4877c76c1003151836r56d03faeh50d8bfd1bb2925cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003151836r56d03faeh50d8bfd1bb2925cf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 15, 2010 at 5:36 PM, Michael Evans <mjevans1983@gmail.com> =
wrote:
> On Sun, Mar 14, 2010 at 10:23 PM, Simon Matthews
> <simon.d.matthews@gmail.com> wrote:
>> I have just built a system and have it booting off a software raid
>> partition. The raid sets use devices /dev/md0, /dev/hd1, /dev/md2,
>> /dev/md3.
>>
>> I now need to transfer some additional disks to this system. These
>> disks are presently in another system where they host a number of ra=
id
>> sets, currently also /dev/md0 - /dev/md4.
>>
>> I need to ensure that the data on the raid set that I am adding to t=
he
>> system is not lost. However, clearly, I can't have the raid sets on
>> these disks come up as /dev/md0-md4. How do I ensure this and have
>> these raid sets come up on /dev/md5 and higher?
>>
>> Simon
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Either use an mdadm.conf to specify the mapping of UUID to md device
> (which will over-ride any auto-detected requests), or use the
> home-host fallback. =A0Obviously the administrator specifying how the=
y'd
> prefer mdadm to assemble the drives is preferable.

I'm not aware of the "home-host fallback" can you give me some pointers=
 on this?
>
> You will probably want to regenerate your initrd; if you are using
> auto-assembly on root without an initrd, I highly suggest upgrading t=
o
> use an initrd/initramfs. =A0You might find this one easy to customize
> for your needs if your distribution lacks one or you dislike the one
> it generates: http://sourceforge.net/projects/aeuio/

=46ortunately Gentoo includes mkinitrd so I can try this if other
methods don't work reliably.

Simon

>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
