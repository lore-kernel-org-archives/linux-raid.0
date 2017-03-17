From: jes.sorensen@gmail.com
Subject: Re: [PATCH v2] mdadm/r5cache: allow adding journal to array without journal
Date: Fri, 17 Mar 2017 15:50:40 -0400
Message-ID: <wrfjlgs3k7hr.fsf@gmail.com>
References: <20170316232405.3523257-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316232405.3523257-1-songliubraving@fb.com> (Song Liu's
        message of "Thu, 16 Mar 2017 16:24:05 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, kernel-team@fb.com
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> Currently, --add-journal can be only used to recreate broken journal
> for arrays with journal since  creation. As the kernel code getting
> more mature, this constraint is no longer necessary.
>
> This patch allows --add-journal to add journal to array without
> journal.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  Manage.c   | 9 ---------
>  mdadm.8.in | 5 ++---
>  2 files changed, 2 insertions(+), 12 deletions(-)

Hi Song,

I spotted this one after I had already applied the first patch with
this title, so I went back and removed the original one and applied this
one instead, but now the build breaks.

When posting a v2, please send it out as a response to the patch it is
meant to replace, like this:
  git send-email --in-reply-to=3D<....>

Second, please put a note in the commit why this is a v2.

I am going to revert them all for now. Please send me a fresh consistent
set to apply.

Thanks,
Jes

cc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb -D=
Sendmail=3D\""/usr/sbin/sendmail -t"\" -DCONFFILE=3D\"/etc/mdadm.conf\" -DC=
ONFFILE2=3D\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=
=3D\"map\" -DMDMON_DIR=3D\"/run/mdadm\" -DFAILED_SLOTS_DIR=3D\"/run/mdadm/f=
ailed-slots\" -DNO_COROSYNC -DNO_DLM -DVERSION=3D\"4.0-10-g707cf0a\" -DVERS=
_DATE=3D"\"2017-03-17\"" -DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Manage.=
o Manage.c
Manage.c: In function =E2=80=98Manage_remove_journal=E2=80=99:
Manage.c:199:26: error: =E2=80=98MD_SB_HAS_JOURNAL=E2=80=99 undeclared (fir=
st use in this function)
  if (!(array.state & (1<<MD_SB_HAS_JOURNAL))) {
                          ^~~~~~~~~~~~~~~~~
Manage.c:199:26: note: each undeclared identifier is reported only once for=
 each function it appears in
Manage.c:203:33: error: =E2=80=98MD_SB_JOURNAL_REMOVABLE=E2=80=99 undeclare=
d (first use in this function)
  } else if (!(array.state & (1<<MD_SB_JOURNAL_REMOVABLE))) {
                                 ^~~~~~~~~~~~~~~~~~~~~~~
<builtin>: recipe for target 'Manage.o' failed
make: *** [Manage.o] Error 1

