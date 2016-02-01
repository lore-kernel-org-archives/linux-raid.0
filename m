From: George Rapp <george.rapp@gmail.com>
Subject: Re: Reshape stuck immediately, backup file all nulls
Date: Sun, 31 Jan 2016 20:02:47 -0500
Message-ID: <CAF-KpgZy4+PGLGV8=x1mq+sXL8KDcGkyHsfuv6OSSxuZAwsHyw@mail.gmail.com>
References: <CABRqA0i7bAB3Xca1a29u2JYOF2UaE_w1sY73se3menp+ExWWKA@mail.gmail.com>
 <56ACEE63.6070108@turmel.org> <CABRqA0jXMyH+TO8Nd47DTAj8RkyFC5bpg07uhXXRb7aU-twHfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABRqA0jXMyH+TO8Nd47DTAj8RkyFC5bpg07uhXXRb7aU-twHfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Bj=C3=B6rn_Augustsson?= <oggust@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 31, 2016 at 9:59 AM, Bj=C3=B6rn Augustsson <oggust@gmail.co=
m> wrote:
>
> On Sat, Jan 30, 2016 at 6:09 PM, Phil Turmel <philip@turmel.org> wrot=
e:
> > Hi Bj=C3=B6rn,
> >
> > The kernel is waiting for mdmon (mdadm as a background task) to ste=
p
> > through the stripes.  mdmon died and the kernel will wait forever.
>
> OK. So I think the root cause here is that my invocation of mdadm was
> unconfined,
> because I was running it interactively. So it could create the backup=
 file.
> But the background version starts via systemd, and runs as mdadm_t, w=
hich
> can't read that file (because it's in /boot). And poof.
>
> I'll file a bug vs the fedora selinux policy for this, too.


Thanks for researching the SELinux vs. mdadm conflict in Fedora that
bit me as well (http://marc.info/?l=3Dlinux-raid&m=3D145349072305613&w=3D=
2).
If your Fedora selinux bug ticket makes it into general distribution,
lots of other users will be helped.

George
--=20
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
