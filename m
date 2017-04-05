From: jes.sorensen@gmail.com
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Wed, 05 Apr 2017 15:02:22 -0400
Message-ID: <wrfjr316d6f5.fsf@gmail.com>
References: <wrfjvaqid9ih.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjvaqid9ih.fsf@gmail.com> (jes sorensen's message of "Wed, 05
        Apr 2017 13:55:34 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

jes.sorensen@gmail.com writes:
> Hi Neil,
>
> Looking through the code in mdadm, I noticed a number of cases calling
> ioctl(RAID_VERSION). At first I had it confused with metadata version,
> but it looks like RAID_VERSION will always return 90000 if it's a valid
> raid device.
>
> In the cases we want to confirm the fd is a valid raid array,
> ioctl(GET_ARRAY_INFO) should do, or sysfs_read(GET_VERSION).
>
> Am I missing something obvious here, or do you see any reason for
> leaving this around?

Sorry the above is wrong, it will always return 900, not 90000. Some of
the code that stood out is in util.c:

int md_get_version(int fd)
{
        struct stat stb;
        mdu_version_t vers;

        if (fstat(fd, &stb)<0)
                return -1;
        if ((S_IFMT&stb.st_mode) != S_IFBLK)
                return -1;

        if (ioctl(fd, RAID_VERSION, &vers) == 0)
                return  (vers.major*10000) + (vers.minor*100) + vers.patchlevel;
        if (errno == EACCES)
                return -1;
        if (major(stb.st_rdev) == MD_MAJOR)
                return (3600);
        return -1;
}

....

int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
{
        /* Initialise kernel's knowledge of array.
         * This varies between externally managed arrays
         * and older kernels
         */
        int vers = md_get_version(mdfd);
        int rv;

#ifndef MDASSEMBLE
        if (st->ss->external)
                rv = sysfs_set_array(info, vers);
        else
#endif
                if ((vers % 100) >= 1) { /* can use different versions */
                mdu_array_info_t inf;
                memset(&inf, 0, sizeof(inf));
                inf.major_version = info->array.major_version;
                inf.minor_version = info->array.minor_version;
                rv = ioctl(mdfd, SET_ARRAY_INFO, &inf);
        } else
                rv = ioctl(mdfd, SET_ARRAY_INFO, NULL);
        return rv;
}

This has been around since at least 2008, the current code came in
f35f25259279573c6274e2783536c0b0a399bdd4, but it looks like even the
prior code made the same assumptions.

In either case, the above 'if ((vers % 100) >= 1)' will always trigger
since the kernel does #define MD_PATCHLEVEL_VERSION 3

It's not like we have been updating MD_PATCHLEVEL_VERSION for a
while. Was the code meant to be looking at the superblock minor version?
I've been staring at this for a while now, so please beat me over the
head if I missed something blatantly obvious.

Jes
