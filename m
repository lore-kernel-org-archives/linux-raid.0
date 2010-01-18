From: Neil Brown <neilb@suse.de>
Subject: Re: [[Patch mdadm] 1/5] Make the IMSM_DEVNAME_AS_SERIAL option work
 when creating containers. This allows a person to testing using loopback
 devices that don't support serial number queries.
Date: Tue, 19 Jan 2010 11:01:31 +1300
Message-ID: <20100119110131.7fa7f33e@notabene>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	<1263242294-5353-2-git-send-email-dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263242294-5353-2-git-send-email-dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, 11 Jan 2010 15:38:10 -0500
Doug Ledford <dledford@redhat.com> wrote:


Applied, thanks.

NeilBrown

> Signed-off-by: Doug Ledford <dledford@redhat.com>
> ---
>  super-intel.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index d6951cc..fcf438c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3208,7 +3208,10 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
>  	dd->fd = fd;
>  	dd->e = NULL;
>  	rv = imsm_read_serial(fd, devname, dd->serial);
> -	if (rv) {
> +	if (rv && check_env("IMSM_DEVNAME_AS_SERIAL")) {
> +		memset(dd->serial, 0, MAX_RAID_SERIAL_LEN);
> +		fd2devname(fd, (char *) dd->serial);
> +	} else if (rv) {
>  		fprintf(stderr,
>  			Name ": failed to retrieve scsi serial, aborting\n");
>  		free(dd);

