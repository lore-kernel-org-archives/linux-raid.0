From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Grow: don't allow to enable PPL when reshape is in
 progress
Date: Fri, 9 Jun 2017 10:58:54 -0400
Message-ID: <6fd58239-5359-45b8-2053-c7617a6775c1@gmail.com>
References: <1497018019-11809-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1497018019-11809-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/09/2017 10:20 AM, Tomasz Majchrzak wrote:
> Don't allow to enable PPL consistency policy when reshape is in progress.
> Current PPL implementation doesn't work when reshape is taking place.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   Grow.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)

Applied!

Thanks,
Jes

