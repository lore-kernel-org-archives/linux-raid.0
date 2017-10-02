From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Grow: stop previous reshape process first
Date: Mon, 2 Oct 2017 15:42:14 -0400
Message-ID: <dd80fc9c-589f-da34-d221-da1ddbae87e6@gmail.com>
References: <1504782076-1664-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1504782076-1664-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/07/2017 07:01 AM, Tomasz Majchrzak wrote:
> If array is stopped during reshape and assembled again straight away,
> reshape process in a background might still be running. systemd doesn't
> start a new service if one already exists. If there is a race, previous
> process might terminate and new one is not created. Reshape doesn't
> continue after assemble.
> 
> Tell systemd to restart the service rather than just start it. It will
> assure previous service is stopped first. If it's not running, stopping
> has no effect and only new process is started.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>   Grow.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes

