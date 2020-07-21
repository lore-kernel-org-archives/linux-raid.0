From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 23/24] init: add an init_mknod helper
Date: Tue, 21 Jul 2020 18:02:46 +0100
Message-ID: <20200721170246.GW2786714@ZenIV.linux.org.uk>
References: <20200721162818.197315-1-hch@lst.de>
 <20200721162818.197315-24-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200721162818.197315-24-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 06:28:17PM +0200, Christoph Hellwig wrote:

> +int __init init_mknod(const char *filename, umode_t mode, unsigned int dev)
> +{
> +	struct dentry *dentry;
> +	struct path path;
> +	int error;
> +
> +	if (S_ISFIFO(mode) || S_ISSOCK(mode))
> +		dev = 0;
> +	else if (!(S_ISBLK(mode) || S_ISCHR(mode)))
> +		return -EINVAL;
> +
> +	dentry = user_path_create(AT_FDCWD, filename, &path, 0);
> +	if (IS_ERR(dentry))
> +		return PTR_ERR(dentry);

user_path_create() is wrong here.

> +
> +	if (!IS_POSIXACL(path.dentry->d_inode))
> +		mode &= ~current_umask();
> +	error = security_path_mknod(&path, dentry, mode, dev);
> +	if (!error)
> +		error = vfs_mknod(path.dentry->d_inode, dentry, mode,
> +				  new_decode_dev(dev));
> +	done_path_create(&path, dentry);
> +	return error;
> +}
> +
>  int __init init_link(const char *oldname, const char *newname)
>  {
>  	struct dentry *new_dentry;
> diff --git a/init/initramfs.c b/init/initramfs.c
> index b1a0a1d5c3c135..bd685fdb5840f3 100644
> --- a/init/initramfs.c
> +++ b/init/initramfs.c
> @@ -359,7 +359,7 @@ static int __init do_name(void)
>  	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
>  		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
>  		if (maybe_link() == 0) {
> -			ksys_mknod(collected, mode, rdev);
> +			init_mknod(collected, mode, rdev);
>  			init_chown(collected, uid, gid, AT_SYMLINK_NOFOLLOW);
>  			init_chmod(collected, mode);
>  			do_utime(collected, mtime);
> diff --git a/init/noinitramfs.c b/init/noinitramfs.c
> index b8bdba1c949cf9..490f2bd2b49979 100644
> --- a/init/noinitramfs.c
> +++ b/init/noinitramfs.c
> @@ -22,8 +22,7 @@ static int __init default_rootfs(void)
>  	if (err < 0)
>  		goto out;
>  
> -	err = ksys_mknod((const char __user __force *) "/dev/console",
> -			S_IFCHR | S_IRUSR | S_IWUSR,
> +	err = init_mknod("/dev/console", S_IFCHR | S_IRUSR | S_IWUSR,
>  			new_encode_dev(MKDEV(5, 1)));
>  	if (err < 0)
>  		goto out;
> -- 
> 2.27.0
> 
