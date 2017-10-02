From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 00/12] Multiple PPL support and PPL bugfixes
Date: Mon, 2 Oct 2017 16:16:06 -0400
Message-ID: <44c99cf5-6c4c-e9ab-ab9d-0e319e82034d@gmail.com>
References: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/28/2017 08:41 AM, Pawel Baldysiak wrote:
> This patchset introduces userspace support for multiple PPLs written in a
> circular buffer. It also contains few general bug fixes for PPL, and
> couple of IMSM specific compatibility patches related to new PPL.
> 
> Artur Paszkiewicz (5):
>    Don't abort starting the array if kernel does not support ppl
>    imsm: don't skip resync when an invalid ppl header is found
>    imsm: always do ppl recovery when starting a rebuilding array
>    imsm: use correct map when validating ppl
>    imsm: write initial ppl on a disk added for rebuild
> 
> Pawel Baldysiak (7):
>    super1: Add support for multiple-ppls
>    imsm: Add support for multiple ppls
>    imsm: validate multiple ppls during assemble
>    Zeroout whole ppl space during creation/force assemble
>    imsm: switch to multiple ppls automatically during assemble
>    Grow: fix switching on PPL during recovery
>    imsm: Write empty PPL header if assembling regular clean array.
> 
>   Grow.c        |   3 -
>   managemon.c   |  11 +++-
>   mdadm.h       |   1 +
>   super-intel.c | 181 ++++++++++++++++++++++++++++++++++++++++++++--------------
>   super1.c      |  70 ++++++++++++++---------
>   sysfs.c       |   6 +-
>   util.c        |  49 ++++++++++++++++
>   7 files changed, 241 insertions(+), 80 deletions(-)

Applied!

Thanks,
Jes

