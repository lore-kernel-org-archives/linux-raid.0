From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/3][mdadm] util.c: include poll.h instead of sys/poll.h
Date: Mon, 08 Feb 2016 10:59:28 -0500
Message-ID: <wrfjzivbdwgv.fsf@redhat.com>
References: <1454711298-32524-1-git-send-email-maxin.john@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454711298-32524-1-git-send-email-maxin.john@gmail.com> (Maxin
	B. John's message of "Sat, 6 Feb 2016 00:28:16 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-raid@vger.kernel.org, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

"Maxin B. John" <maxin.john@gmail.com> writes:
> From: "Maxin B. John" <maxin.john@intel.com>
>
> This fixes a compile warning when building with musl:
>
>  In file included from util.c:27:0:
>  |
>  qemux86-64/usr/include/sys/poll.h:1:2:
>  error: #warning redirecting incorrect #include <sys/poll.h> to <poll.h>
>  [-Werror=cpp]
>  |  #warning redirecting incorrect #include <sys/poll.h> to <poll.h>
>  |   ^
>
> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> ---
>  util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes

>
> diff --git a/util.c b/util.c
> index 970d484..3e6d293 100644
> --- a/util.c
> +++ b/util.c
> @@ -24,7 +24,6 @@
>  
>  #include	"mdadm.h"
>  #include	"md_p.h"
> -#include	<sys/poll.h>
>  #include	<sys/socket.h>
>  #include	<sys/utsname.h>
>  #include	<sys/wait.h>
> @@ -32,6 +31,7 @@
>  #include	<sys/resource.h>
>  #include	<sys/vfs.h>
>  #include	<linux/magic.h>
> +#include	<poll.h>
>  #include	<ctype.h>
>  #include	<dirent.h>
>  #include	<signal.h>
