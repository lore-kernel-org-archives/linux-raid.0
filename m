From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 16/24] init: add an init_chroot helper
Date: Tue, 21 Jul 2020 18:10:36 +0100
Message-ID: <20200721171036.GX2786714@ZenIV.linux.org.uk>
References: <20200721162818.197315-1-hch@lst.de>
 <20200721162818.197315-17-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200721162818.197315-17-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 06:28:10PM +0200, Christoph Hellwig wrote:

> +int __init init_chroot(const char *filename)
> +{
> +	struct path path;
> +	int error;
> +
> +	error = kern_path(filename, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
> +	if (error)
> +		return error;
> +	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);

Matter of taste, but if we do that, I wonder if we would be better off with
	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
	if (!error && !ns_capable(current_user_ns(), CAP_SYS_CHROOT))
		error = -EPERM;
	if (!error)
		error = security_path_chroot(&path);
	if (!error)
		set_fs_root(current->fs, &path);
	path_put(&path);
	return error;
