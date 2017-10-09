From: Michael Lyle <mlyle@lyle.org>
Subject: Re: [PATCH] bcache: mark expected switch fall-throughs in STRTO_H
Date: Mon, 9 Oct 2017 15:52:30 -0700
Message-ID: <3d61a470-f8ba-b40c-745e-468d68152607@lyle.org>
References: <20171009215425.GA21563@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171009215425.GA21563@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 10/09/2017 02:54 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-bcache@vger.kernel.org
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com
Reviewed-by: Michael Lyle <mlyle@lyle.org>

Looks good to me.

Thanks,

Mike
