From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 2.6.23-rc7 1/3] async_tx: usage documentation and developer
 notes
Date: Fri, 21 Sep 2007 09:05:56 -0400
Message-ID: <46F3C1B4.6040804@tmr.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com> <20070921012740.17157.49639.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070921012740.17157.49639.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com, shannon.nelson@intel.com
List-Id: linux-raid.ids

Dan Williams wrote:
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>
>  Documentation/crypto/async-tx-api.txt |  217 +++++++++++++++++++++++++++++++++
>  1 files changed, 217 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/crypto/async-tx-api.txt b/Documentation/crypto/async-tx-api.txt
> new file mode 100644
> index 0000000..48d685a
> --- /dev/null
> +++ b/Documentation/crypto/async-tx-api.txt
> @@ -0,0 +1,217 @@
> +		 Asynchronous Transfers/Transforms API
> +
> +1 INTRODUCTION
> +
> +2 GENEALOGY
> +
> +3 USAGE
> +3.1 General format of the API
> +3.2 Supported operations
> +3.2 Descriptor management
> +3.3 When does the operation execute?
> +3.4 When does the operation complete?
> +3.5 Constraints
> +3.6 Example
> +

This is very readable, and appears extensible to any new forthcoming 
technology I'm aware of. Great job!

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

