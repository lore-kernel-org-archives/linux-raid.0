From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: Re: mdadm git 32bit build errors
Date: Tue, 3 Jan 2017 15:24:54 +0100
Message-ID: <62a5db74-939b-d845-dfa7-d3bd51d8ed9c@intel.com>
References: <77032f07-d246-ade3-a133-10ccfa43c1ad@mageia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <77032f07-d246-ade3-a133-10ccfa43c1ad@mageia.org>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Backlund <tmb@mageia.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Thanks for reporting this issue.
I've just made a patch for that and sent it here.

Thanks
Pawel Baldysiak

On 01/02/2017 05:35 PM, Thomas Backlund wrote:
>
> Trying to build current mdadm git fails on 32bit with:
>
>
>
> super-intel.c: In function 'copy_metadata_imsm':
> super-intel.c:1948:35: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
>   if (read(from, buf, sector_size) != sector_size)
>                                    ^
> super-intel.c: In function 'read_imsm_migr_rec':
> super-intel.c:2820:40: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
>       MIGR_REC_BUF_SECTORS*sector_size) !=
>                                         ^
> super-intel.c: In function 'write_imsm_migr_rec':
> super-intel.c:3022:41: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
>        MIGR_REC_BUF_SECTORS*sector_size) !=
>                                          ^
> super-intel.c: In function 'load_imsm_mpb':
> super-intel.c:4125:36: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
>   if (read(fd, anchor, sector_size) != sector_size) {
>                                     ^
> super-intel.c: In function 'add_to_super_imsm':
> super-intel.c:5641:48: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
>        MIGR_REC_BUF_SECTORS*super->sector_size) !=
>                                                 ^
> super-intel.c: In function 'write_super_imsm':
> super-intel.c:5851:43: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
>          MIGR_REC_BUF_SECTORS*sector_size) !=
>                                            ^
> super-intel.c: In function 'store_imsm_mpb':
> super-intel.c:8093:34: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
>   if (write(fd, buf, sector_size) != sector_size)
>                                   ^
> super-intel.c: In function 'imsm_manage_reshape':
> super-intel.c:11505:42: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
>         MIGR_REC_BUF_SECTORS*sector_size) !=
>                                           ^
> cc1: all warnings being treated as errors
>
>
> Seems to be introduced by:
> https://git.kernel.org/cgit/utils/mdadm/mdadm.git/commit/super-intel.c?id=de44e46fd4703ea286987d1d0cf775efa62700fd
>
>
>
> 64bit build is ok.
>
> gcc is 5.4.0
>
> --
> Thomas
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
