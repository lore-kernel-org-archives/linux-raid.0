From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 3 Mar 2004 12:24:18 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16453.13250.331087.281490@notabene.cse.unsw.edu.au>
References: <40453152.462.2FC95FD@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Evans on Wednesday March 3
To: Chris Evans <chris1@psyctc.org>
Cc: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 3, chris1@psyctc.org wrote:
> Aha, didn't know that wrinkle: lovely.  Mount says:
> /dev/md0 on / type ext3 (rw,errors=remount-ro)
> proc on /proc type proc (rw)
> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> 
> and cat /proc/mounts says:
> rootfs / rootfs rw 0 0
> /dev/root / ext2 rw 0 0
> proc /proc proc rw 0 0
> devpts /dev/pts devpts rw 0 0
> 
> Does that "/dev/root" bit indicate anything useful?

No, but the fact that root is actually 'ext2' even though mount (and
presumably fstab) thinks it is ext3 is a bit suspicious. 

> > Exactly how did you tell lilo to use /dev/md0?
> > With
> >    root=/dev/md0
> > as an option in lilo.conf, or with
> >    append= "root=/dev/md0"
> 
> I think I've only tried the former (with and without an earlier line, 
> before the image stanzas, saying root=/dev/hdb1)

If there are any "root=/dev/hdb1" lines in lilo.conf, I suggest taking
them out.
I think you currently have /dev/hdb1 as your root filesystem still.
You can easily check this:

   mkdir /a /b
   mount /dev/hdb1 /a
   mount /dev/md0 /b
   > /a-file
   ls -l /?/a-file

If the ls finds "/a/a-file", then /dev/hdb1 is root.
If it finds /b/a-file, then /dev/md0 is root.

If it still doesn't work, post your lilo.conf

NeilBrown
