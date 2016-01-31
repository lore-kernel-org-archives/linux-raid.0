From: =?UTF-8?Q?Bj=C3=B6rn_Augustsson?= <oggust@gmail.com>
Subject: Re: Reshape stuck immediately, backup file all nulls
Date: Sun, 31 Jan 2016 15:59:41 +0100
Message-ID: <CABRqA0jXMyH+TO8Nd47DTAj8RkyFC5bpg07uhXXRb7aU-twHfA@mail.gmail.com>
References: <CABRqA0i7bAB3Xca1a29u2JYOF2UaE_w1sY73se3menp+ExWWKA@mail.gmail.com>
	<56ACEE63.6070108@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56ACEE63.6070108@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 30, 2016 at 6:09 PM, Phil Turmel <philip@turmel.org> wrote:
> Hi Bj=C3=B6rn,
>
> On 01/30/2016 07:21 AM, Bj=C3=B6rn Augustsson wrote:
>
>> The question is, what kind of state am in now?
>
> The kernel is waiting for mdmon (mdadm as a background task) to step
> through the stripes.  mdmon died and the kernel will wait forever.

OK. So I think the root cause here is that my invocation of mdadm was
unconfined,
because I was running it interactively. So it could create the backup f=
ile.
But the background version starts via systemd, and runs as mdadm_t, whi=
ch
can't read that file (because it's in /boot). And poof.

I'll file a bug vs the fedora selinux policy for this, too.

>> And how should I recover?
>> Will just adding a policy to allow access to that file, and then
>> mdadm --grow --continue /dev/md127
>> fix it?
>
> Probably.  Others have fixed this by disabling selinux for the reshap=
e.
>  Don't forget to specify --backup-file again on the command line.  (I
> don't use selinux myself, so I can't be more specific.)

Yeah, this seems to be working.
mdadm --grow --continue --backup-file=3D/boot/grow_md127.bak /dev/md127
is running, and the counters in /proc/mdstat started moving. It's going=
 to be
a day or two for this to complete, but right now things are looking goo=
d.

Thanks for the help!

/August.

> In the future, consider not using a backup file at all -- mdadm
> generally leaves enough dead space on devices to avoid the need.
>
>> Is the broken backup file going to be a problem?
>
> Shouldn't be. Report back if it is.
>
> Phil



--=20
Wrong on most accounts.  const Foo *foo; and Foo const *foo; mean the s=
ame: foo
being a pointer to const Foo.  const Foo const *foo; would mean the sam=
e but is
illegal (double const).  You are confusing this with Foo * const foo; a=
nd const
=46oo * const foo; respectively. -David Kastrup, comp.os.linux.developm=
ent.system
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
