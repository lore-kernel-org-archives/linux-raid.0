From: Daniel van Eeden <daniel.van.eeden@myname.nl>
Subject: Bug#444682: [PATCH] Fix segfault on assembly on amd64 with v1 superblocks
Date: Sun, 30 Sep 2007 14:43:01 +0200
Message-ID: <1191156182.10754.2.camel@pc1.myname.nl>
References: 20070930113456.GA8924@lapse.madduck.net <1191154976-12311-1-git-send-email-madduck@debian.org>
	 <1191154976-12311-2-git-send-email-madduck@debian.org>
Reply-To: Daniel van Eeden <daniel.van.eeden@myname.nl>,
	444682-quiet@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <bounce-debian-bugs-rc=glddbr-debian-bugs-rc=gmane.org@lists.debian.org>
Resent-To: 
Resent-Message-ID: <handler.444682.Q444682.119115624625760@bugs.debian.org>
In-Reply-To: <1191154976-12311-2-git-send-email-madduck@debian.org>
List-Post: <mailto:debian-bugs-rc@lists.debian.org>
List-Help: <mailto:debian-bugs-rc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=unsubscribe>
To: "martin f. krafft" <madduck@debian.org>, 444682-quiet@bugs.debian.org
Cc: linux-raid@vger.kernel.org, 444682-submitter@bugs.debian.org
List-Id: linux-raid.ids

I've tested this patch and it works :)

Daniel


On Sun, 2007-09-30 at 13:22 +0100, martin f. krafft wrote:
> Commit a40b4fe introduced a temporary supertype variable tst, instead of
> manipulating st directly. However, it was forgotton to pass &tst into the
> recursive load_super1 call, causing an infinite recursion.
> 
> Signed-off-by: martin f. krafft <madduck@debian.org>
> ---
>  super1.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/super1.c b/super1.c
> index 52783e7..06c2655 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1001,7 +1001,7 @@ static int load_super1(struct supertype *st, int fd, void **sbp, char *devname)
>  		/* guess... choose latest ctime */
>  		tst.ss = &super1;
>  		for (tst.minor_version = 0; tst.minor_version <= 2 ; tst.minor_version++) {
> -			switch(load_super1(st, fd, sbp, devname)) {
> +			switch(load_super1(&tst, fd, sbp, devname)) {
>  			case 0: super = *sbp;
>  				if (bestvers == -1 ||
>  				    bestctime < __le64_to_cpu(super->ctime)) {
