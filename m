From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 21/24] init: add an init_symlink helper
Date: Tue, 21 Jul 2020 18:00:53 +0100
Message-ID: <20200721170053.GV2786714@ZenIV.linux.org.uk>
References: <20200721162818.197315-1-hch@lst.de>
 <20200721162818.197315-22-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200721162818.197315-22-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 06:28:15PM +0200, Christoph Hellwig wrote:
> Add a simple helper to symlink with a kernel space file name and switch
> the early init code over to it.  Remove the now unused ksys_symlink.

> +int __init init_symlink(const char *oldname, const char *newname)
> +{
> +	struct filename *from = getname_kernel(oldname);

What the hell for?  You are only using from ->name later.

> +	struct dentry *dentry;
> +	struct path path;
> +	int error;
> +
> +	if (IS_ERR(from))
> +		return PTR_ERR(from);
> +	dentry = kern_path_create(AT_FDCWD, newname, &path, 0);
> +	error = PTR_ERR(dentry);
> +	if (IS_ERR(dentry))
> +		goto out_putname;
> +	error = security_path_symlink(&path, dentry, from->name);
> +	if (!error)
> +		error = vfs_symlink(path.dentry->d_inode, dentry, from->name);
> +	done_path_create(&path, dentry);
> +out_putname:
> +	putname(from);
> +	return error;
> +}

And again, the same comment regarding the location of file.
