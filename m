From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH,v2] Block overwriting existing links while manual assembly
Date: Fri, 5 Jun 2020 11:14:19 -0400
Message-ID: <e04a6c51-9941-e65a-2170-277f367d8436@trained-monkey.org>
References: <20200529063136.8177-1-kinga.tanska@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200529063136.8177-1-kinga.tanska@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/29/20 2:31 AM, Kinga Tanska wrote:
> Manual assembly with existing link caused overwriting
> this link. Add checking link and block this situation.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Assemble.c | 4 ++++
>  1 file changed, 4 insertions(+)

Applied!

Thanks,
Jes
