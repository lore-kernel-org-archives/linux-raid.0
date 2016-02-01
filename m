From: =?UTF-8?Q?Bj=C3=B6rn_Augustsson?= <oggust@gmail.com>
Subject: Re: Reshape stuck immediately, backup file all nulls
Date: Mon, 1 Feb 2016 19:45:28 +0100
Message-ID: <CABRqA0g7tZnyo0FO9sHH4UrSjL03XrChHxfc1FKKcbnHZQDv-Q@mail.gmail.com>
References: <CABRqA0i7bAB3Xca1a29u2JYOF2UaE_w1sY73se3menp+ExWWKA@mail.gmail.com>
	<56ACEE63.6070108@turmel.org>
	<CABRqA0jXMyH+TO8Nd47DTAj8RkyFC5bpg07uhXXRb7aU-twHfA@mail.gmail.com>
	<CAF-KpgZy4+PGLGV8=x1mq+sXL8KDcGkyHsfuv6OSSxuZAwsHyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgZy4+PGLGV8=x1mq+sXL8KDcGkyHsfuv6OSSxuZAwsHyw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 1, 2016 at 2:02 AM, George Rapp <george.rapp@gmail.com> wro=
te:
> On Sun, Jan 31, 2016 at 9:59 AM, Bj=C3=B6rn Augustsson <oggust@gmail.=
com> wrote:
>>
>> On Sat, Jan 30, 2016 at 6:09 PM, Phil Turmel <philip@turmel.org> wro=
te:
>> > Hi Bj=C3=B6rn,
>> >
>> > The kernel is waiting for mdmon (mdadm as a background task) to st=
ep
>> > through the stripes.  mdmon died and the kernel will wait forever.
>>
>> OK. So I think the root cause here is that my invocation of mdadm wa=
s
>> unconfined,
>> because I was running it interactively. So it could create the backu=
p file.
>> But the background version starts via systemd, and runs as mdadm_t, =
which
>> can't read that file (because it's in /boot). And poof.
>>
>> I'll file a bug vs the fedora selinux policy for this, too.
>
>
> Thanks for researching the SELinux vs. mdadm conflict in Fedora that
> bit me as well (http://marc.info/?l=3Dlinux-raid&m=3D145349072305613&=
w=3D2).
> If your Fedora selinux bug ticket makes it into general distribution,
> lots of other users will be helped.

marc.info appears to be down, at least for me.
Searching some more I found this though, and I guess it's it - it
sounds like exactly the same problem:
http://www.spinics.net/lists/raid/msg50735.html

I filed the bug with Fedora, at
https://bugzilla.redhat.com/show_bug.cgi?id=3D1303650

Let's hope this gets resolved. Storage/RAID issues like this make me ne=
rvous.

/August.

> George
> --
> George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
> LinkedIn profile: https://www.linkedin.com/in/georgerapp
> Phone: +1 740 936 RAPP (740 936 7277)



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
