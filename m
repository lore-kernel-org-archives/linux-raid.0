From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Wed, 2 Nov 2011 20:51:59 +0100
Message-ID: <CAPXgP110ptkjWw3DP5t7YRx2mj+2GtkX0z5CrFZ4fZ3+BuYMYA@mail.gmail.com>
References: <20110208094843.GD11446@tango.0pointer.de> <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
 <20110208110730.GF23157@tango.0pointer.de> <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
 <20110208172822.GC21847@tango.0pointer.de> <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de> <20111102114416.7879b77f@notabene.brown>
 <20111102011615.GA5289@tango.0pointer.de> <20111102130334.09c3ab51@notabene.brown>
 <20111102133223.GC5119@tango.0pointer.de> <CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
 <CABE8wwt623R1bvFuUe_HuKXevnY9vTC8e5gkCK5rFyg8UrJy7g@mail.gmail.com>
 <CAPXgP137YTTOMxvAAbH3vrWw5aWvkBQUtK903teYgib8=E=8Xw@mail.gmail.com> <CABE8wwuRgWng=+WUotb2kqtQZU8=xmn8cZtiUy9hnj3mMgM_gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwuRgWng=+WUotb2kqtQZU8=xmn8cZtiUy9hnj3mMgM_gQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Lennart Poettering <lennart@poettering.net>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Wed, Nov 2, 2011 at 20:31, Williams, Dan J <dan.j.williams@intel.com=
> wrote:
> On Wed, Nov 2, 2011 at 11:49 AM, Kay Sievers <kay.sievers@vrfy.org> w=
rote:
>> On Wed, Nov 2, 2011 at 19:16, Williams, Dan J <dan.j.williams@intel.=
com> wrote:
>>> On Wed, Nov 2, 2011 at 7:33 AM, Kay Sievers <kay.sievers@vrfy.org> =
wrote:
>>>> People who like to put their rootfs on a userspace managed raid de=
vice
>>>> just get what they asked for. :)
>>>
>>> Proper care and feeding of mdmon and userspace managed block device=
s /
>>> filesystems is a solvable problem. =C2=A0To me the ":)" runs the ri=
sk of
>>> implying we don't think we can get this right.
>>
>> It implied that I think it is totally insane what you guys try to
>> accomplish. Managing the rootfs blockdev with tools contained in the
>> rootfs itself is just crazy. No smiley this time.
>>
>
> Yes, much clearer. =C2=A0Which is why the "never let mdmon run from a=
n fs
> it is managing" is better than the current dance that was implemented
> to address the need to drop initramfs memory and get around a lack of
> having a filesystem (like /run) that persisted from early boot. =C2=A0=
But
> we now run back into the problem of pinning initramfs memory. =C2=A0D=
oes
> systemd already expect that the full initramfs sticks around to handl=
e
> shutdown? =C2=A0If so then we have come full circle and don't really =
need
> the "mdmon --takeover" functionality versus just letting the
> initramfs-mdmon handle their entire lifetime of the rootfs blockdev.

It all depends on the initramfs implementation. Systemd is not
involved here and has no knowledge about what was left behind, it just
checks if there is binary in /run provided by initramfs, and then it
calls this binary instead of just bringing down the box itself.

So far only dracut implements this shutdown logic, which is just a
go-back-to initramfs and disassemble/shut down everything that was
assembled before the initramfs started the real init.

I wouldn't be surprised if we see more of these use cases from
subsystems which put their rootfs on something that needs to be
managed from userspace.

The pinned memory for the tools in initramfs that stay around in tmpfs
is probably the price to pay for these kinds of setups of the rootfs,
when subsystems want to avoid adding the needed logic to the kernel to
safely shut down the rootfs.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
