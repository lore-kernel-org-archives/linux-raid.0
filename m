From: Jes Sorensen <jsorensen@fb.com>
Subject: Re: [mdadm PATCH 1/1] Fix a build error
Date: Fri, 29 Sep 2017 17:47:25 -0400
Message-ID: <ef3ae89b-89d4-84cf-ae19-ebb9de0aa79e@fb.com>
References: <1505879308-6077-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1505879308-6077-1-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, pmenzel@molgen.mpg.de, antlists@youngman.org.uk
List-Id: linux-raid.ids

On 09/19/2017 11:48 PM, Xiao Ni wrote:
> On the s390 platform the build fails with the error below.
> Manage.c: In function 'Manage_subdevs':
> Manage.c:1502:5: error: passing argument 3 of 'fstat_is_blkdev' from incompatible pointer type [-Werror]
>       fstat_is_blkdev(tfd, dv->devname, &rdev);
>       ^
> In file included from Manage.c:25:0:
> mdadm.h:1446:12: note: expected 'dev_t *' but argument is of type 'long unsigned int *'
> 
> It was introduced by commit 0a6bff09 (mdadm/util: unify fstat
> checking blkdev into function). It needs to pass a type 'dev_t'
> argument to fstat_is_blkdev, but it passes a type 'unsigned
> long' argument. So use a temporary variable to fix this.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Suggested-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Suggested-by: Wols Lists <antlists@youngman.org.uk>
> ---
>   Manage.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)

So having a quick look at this, I have to say I don't like the casting 
back and forth. The fact that we carry rdev in an unsigned long in 
Manage_subdevs() seems dubious to me.

Did you look into what the implications would be to change it to a dev_t?

Jes
