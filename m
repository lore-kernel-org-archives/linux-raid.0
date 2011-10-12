From: Michal Soltys <soltys@ziu.info>
Subject: Re: Odd booting problem
Date: Thu, 13 Oct 2011 00:41:01 +0200
Message-ID: <4E96177D.8020804@ziu.info>
References: <4E8F8C63.1080600@gmail.com> <4E9316F8.7040800@gmail.com> <4E933557.1040909@ziu.info> <4E95FEAE.1090809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E95FEAE.1090809@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11-10-12 22:55, maurice wrote:
> Problem Solved!
>
> So far so good.
>
> BUT: as I found, and for unclear reasons, there was no 'proc' on the
> file system present
> on /dev/md1 (which was intended as our new /).
>
> So dracut gets into a loop despite of ROOTFS_MOUNTED being already set:
>
> + [ -d /sysroot/proc ]
> + . /mount/99mount-root.sh
> ...
> + [ -n block:/dev/md1 -a -z ]
> + mount -t auto -o ro /dev/md1 /sysroot
> mount: /dev/md1 already mounted or /sysroot busy
> mount: according to mtab, /dev/md1 is already mounted on /sysroot
>
> That is absolutely true but not particularly illuminating.
> Eventually this ends, quite late,
>

For the record, the loop you're talking about sources mount hooks of 
each module that installs one. And those hooks are internally 
responsible for mounting. The "success" check is, if /proc directory 
showed up at /sysroot point. So yea, for certain unusual situations it 
could be more precise/verbose. I'll prep a patch for that.

Btw, the version you reported offlist, is relatively old (current is 013 
with quite a few commits ahead). FYI

> Then why not offer to run 'mkdir -p /sysroot/{dev,proc,sys}'?
> Do this after making sysroot writeable and then continue?
>

IMHO the init script itself should keep its hands off the filesystem.

It's prefectly fine though to create a module that would do that through 
e.g. a pre-pivot hook - but that's distro's/user's policy, or module's 
specific necessity.

PS. If you run into other dracut-related issues, initramfs@vger will 
likely get you answer faster.
