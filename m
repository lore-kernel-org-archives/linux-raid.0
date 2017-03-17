From: jes.sorensen@gmail.com
Subject: Re: [PATCH 0/4] mdadm:checking level once mode has been set
Date: Fri, 17 Mar 2017 15:30:08 -0400
Message-ID: <wrfjy3w3k8fz.fsf@gmail.com>
References: <20170308074831.24683-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170308074831.24683-1-zlliu@suse.com> (Zhilong Liu's message of
        "Wed, 8 Mar 2017 15:48:31 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> mdadm: it would be better to check --level ealier,
> because it would fall to different prompt if user
> forgets to specify the --level. such as:
> ./mdadm -CR /dev/md0 -b internal -n2 -x1 /dev/loop[0-2]
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

This patchset is completely messed up - 0/4 contains actual code instead
of being a cover letter. 5/5 is a reply to 1/4 and you posted a v1 of
something which I assume needs to be the v2 given the v1 is the original
posting.

Would you mind sending out a clean set of these patches?

Thanks,
Jes
