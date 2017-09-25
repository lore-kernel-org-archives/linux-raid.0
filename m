From: "John Stoffel" <john@stoffel.org>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.
Date: Mon, 25 Sep 2017 11:26:14 -0400
Message-ID: <22985.8214.251962.72926@quad.stoffel.home>
References: <87y3p372b0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3p372b0.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:

NeilBrown> Creating an array by opening a block-device with major number of 9
NeilBrown> will transparently load the md module if needed.
NeilBrown> Creating an array by opening
NeilBrown>    /sys/module/md_mod/parameters/new_array
NeilBrown> and writing to it won't, it will just fail if md_mod isn't loaded.

NeilBrown> So when opening that file fails with ENOENT, run "modprobe md_mod" and
NeilBrown> try again.

NeilBrown> This fixes a bug whereby if you have "CREATE names=yes" in mdadm.conf,
NeilBrown> and the md modules isn't loaded, then creating or assembling an
NeilBrown> array will not honor the "names=yes" configuration.

NeilBrown> Signed-off-by: NeilBrown <neilb@suse.com>
NeilBrown> ---
NeilBrown>  mdopen.c | 4 ++++
NeilBrown>  1 file changed, 4 insertions(+)

NeilBrown> diff --git a/mdopen.c b/mdopen.c
NeilBrown> index 3c0052f2db23..dcdc6f23e6c1 100644
NeilBrown> --- a/mdopen.c
NeilBrown> +++ b/mdopen.c
NeilBrown> @@ -312,6 +312,10 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
NeilBrown>  		if (block_udev)
NeilBrown>  			udev_block(devnm);
NeilBrown>  		fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
NeilBrown> +		if (fd < 0 && errno == ENOENT) {
NeilBrown> +			system("modprobe md_mod");
NeilBrown> +			fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
NeilBrown> +		}
NeilBrown>  		if (fd >= 0) {
NeilBrown>  			n = write(fd, devnm, strlen(devnm));
NeilBrown>  			close(fd);
NeilBrown> -- 
NeilBrown> 2.14.0.rc0.dirty

I haven't looked, but shouldn't the path for modprobe be hardcoded
here to /sbin/modprobe?  Or the PATH sanitized so that random people
can't put something into the system PATH and cause problems? 

