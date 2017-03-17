From: jes.sorensen@gmail.com
Subject: Re: [PATCH 3/3] mdadm: Specify enough length when write to buffer
Date: Fri, 17 Mar 2017 15:58:35 -0400
Message-ID: <wrfj8to3k74k.fsf@gmail.com>
References: <1489751743-11397-1-git-send-email-xni@redhat.com>
        <1489751743-11397-4-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489751743-11397-4-git-send-email-xni@redhat.com> (Xiao Ni's
        message of "Fri, 17 Mar 2017 19:55:43 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> In Detail.c the buffer path in function Detail is defined as path[200],
> in fact the max lenth of content which needs to write to the buffer is
> 287. Because the length of dname of struct dirent is 255.
> During building it reports error:
> error: =E2=80=98%s=E2=80=99 directive writing up to 255 bytes into a regi=
on of size 189
> [-Werror=3Dformat-overflow=3D]
>
> In function examine_super0 there is a buffer nb with length 5.
> But it need to show a int type argument. The lenght of max
> number of int is 10. So the buffer length should be 11.
>
> In human_size function the length of buf is 30. During building
> there is a error:
> output between 20 and 47 bytes into a destination of size 30.
> Change the length to 47.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Detail.c | 2 +-
>  super0.c | 2 +-
>  util.c   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Applied!

Thanks!
Jes
