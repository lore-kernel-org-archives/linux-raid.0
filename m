From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 1/1] super1: Always round data offset to 1M
Date: Thu, 27 Jul 2017 05:32:47 -0400
Message-ID: <aa337a46-cf17-c438-2dcc-9428e756c7b3@gmail.com>
References: <20170726144154.31798-1-pawel.baldysiak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170726144154.31798-1-pawel.baldysiak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/26/2017 10:41 AM, Pawel Baldysiak wrote:
> Currently if metadata requires more then 1M,
> data offset will be rounded down to closest MB.
> This is not correct, since less then required space is reserved.
> Always round data offset up to multiple of 1M.
> 
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>   super1.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Applied

Thanks,
Jes

