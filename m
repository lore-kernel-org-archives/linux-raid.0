From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Need information regarding RAID 6 Async APIs for kernel version
	2.6.27
Date: Thu, 28 May 2009 15:56:09 -0700
Message-ID: <e9c3a7c20905281556p819f97gc411335bf7b632e9@mail.gmail.com>
References: <loom.20090528T173957-742@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20090528T173957-742@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Koti <satha_koti@yahoo.co.in>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 28, 2009 at 10:57 AM, Koti <satha_koti@yahoo.co.in> wrote:
> Hi All,
>
> When I am using the linux kernel version 2.6.21, I applied the RAID5 and RAID6
> Async_tx APIs, and those are working fine.
>
> But When I upgraded to linux kernel version 2.6.27, it has RAID5 async_tx APIs
> inline, but not the RAID6.
>
> I downloaded the recent RAID6 async_tx APIs released on March2009, from the
> links
>
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6
>
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git raid6-for-neil
>
>
> The following is my questions:
> 1) Is these are suitable for my kernel version, if not can you please provide
> me the link where I can get the patches for this kernel.

The most up to date code is found in:
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

It is based on the 2.6.29 kernel plus the patches that were merged for
drivers/md/ during the 2.6.30 merge window.  There is currently no
plan to provide updated patches for kernel versions prior to 2.6.29.

> 1) If these are currect one Iam looking, then I have a few more doubts while
> traversing the code, It has async calls like async_pq, async_r6_dd_recov, ...
> From where these functions are invoked
> how the link happens between these async calls and the md-raid driver.
>
> Can anybody help in solving this problem, it is very useful for my work.
> Thanks in advance for your support.

Please try the latest code in the raid6 branch, it has been updated
according to review comments and includes the changes to
drivers/md/raid5.c to invoke asynchronous raid6 operation.  Note that
this branch of the tree will periodically rebase as review feedback is
incorporated into the patches.  I understand this makes the tree
difficult to track with git.  My recommendation is to add it as a
remote branch and use git fetch and git reset to stay up to date:

git remote add async_tx
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git
git fetch async_tx
git checkout -b test-raid6 async_tx/raid6

...then to update (assuming you are still on the test-raid6 branch):
git fetch async_tx
git reset async_tx/raid6

Regards,
Dan
