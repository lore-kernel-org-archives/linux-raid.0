From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 05/17] Util: get device size from id
Date: Thu, 04 Nov 2010 22:42:30 -0700
Message-ID: <4CD39946.5000809@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FBF@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FBF@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/29/2010 7:19 AM, Czarnowska, Anna wrote:
>  From c0bbe01f5f73d123af899338e838d45df1a4abee Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska<anna.czarnowska@intel.com>
> Date: Fri, 22 Oct 2010 13:23:15 +0200
> Subject: [PATCH 05/17] Util: get device size from id
>
> Signed-off-by: Anna Czarnowska<anna.czarnowska@intel.com>
> ---
>   mdadm.h |    1 +
>   util.c  |   18 ++++++++++++++++++
>   2 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/mdadm.h b/mdadm.h
> index 450fb11..66363fb 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -745,6 +745,7 @@ static inline struct supertype *guess_super(int fd) {
>   }
>   extern struct supertype *dup_super(struct supertype *st);
>   extern int get_dev_size(int fd, char *dname, unsigned long long *sizep);
> +extern int dev_size_from_id(unsigned id, unsigned long long *size);

Small nits:

id should be dev_t.

...and this patch should be squashed into the patch that uses it.
