From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: LVM and Raid5
Date: Mon, 21 Sep 2009 09:30:09 -0700 (PDT)
Message-ID: <684876.38078.qm@web51302.mail.re2.yahoo.com>
References: <170fa0d20909210733p2e3e797cvb60af2e9bd153fda@mail.gmail.com>
Reply-To: Jon@eHardcastle.com,
	LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <170fa0d20909210733p2e3e797cvb60af2e9bd153fda@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: Michal Soltys <soltys@ziu.info>, Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org, Linux Raid Study <linuxraid.study@gmail.com>, linux-lvm@redhat.com
List-Id: linux-raid.ids

--- On Mon, 21/9/09, Mike Snitzer <snitzer@gmail.com> wrote:

> From: Mike Snitzer <snitzer@gmail.com>
> Subject: Re: LVM and Raid5
> To: "Michal Soltys" <soltys@ziu.info>
> Cc: "Linux Raid Study" <linuxraid.study@gmail.com>, linux-raid@vger.ker=
nel.org, linux-lvm@redhat.com
> Date: Monday, 21 September, 2009, 3:33 PM
> On Thu, Sep 17, 2009 at 8:37 AM,
> Michal Soltys <soltys@ziu.info>
> wrote:
> > Linux Raid Study wrote:
> >>
> >> Hello:
> >>
> >> Has someone experimented with LVM and Raid5
> together (on say, 2.6.27)?
> >> Is there any performance drop if LVM/Raid5 are
> combined vs Raid5 alone?
> >>
> >> Thanks for your inputs!
> >
> > Few things to consider when setting up LVM on MD
> raid:
> >
> > - readahead set on lvm device
> >
> > It defaults to 256 on any LVM device, while MD will
> set it accordingly to
> > the amount of disks present in the raid. If you do
> tests on a filesystem,
> > you may see significant differences due to that. YMMV
> depending on the type
> > of used benchmark(s).
> >
> > - filesystem awareness of underlying raid
> >
> > For example, xfs created on top of raid, will
> generally get the parameters
> > right (stripe unit, stripe width), but if it's xfs on
> lvm on raid, then it
> > won't - you will have to provide them manually.
> >
> > - alignment between LVM chunks and MD chunks
> >
> > Make sure that extent area used for actual logical
> volumes start at the
> > boundary of stripe unit - you can adjust the LVM's
> metadata size during
> > pvcreate (by default it's 192KiB, so with non-default
> stripe unit it may
> > cause issues, although I vaguely recall posts that
> current LVM is MD aware
> > during initialization). Of course LVM must itself
> start at the boundary for
> > that to make any sense (and it doesn't have to be the
> case - for example if
> > you use partitionable MD).
>=20
> All of the above have been resolved in recent LVM2
> userspace (2.02.51
> being the most recent release with all these
> addressed).=A0 The last
> issue you mention (partitionable MD alignment offset) is
> also resolved
> when a recent LVM2 is coupled with Linux 2.6.31 (which
> provides IO
> Topology support).
>=20
> Mike
> --

When you say 'resolved' are we talking automatically? if so, when the vol=
umes are created... etc etc?
-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.=
'
-----------------------





     =20

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
