From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] Restrict the use area of the log_offset variable
Date: Fri, 4 Nov 2016 15:05:26 -0700
Message-ID: <20161104220526.2lbhck5rqvar2idd@kernel.org>
References: <20161102090239.11137-1-liuyun01@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161102090239.11137-1-liuyun01@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: JackieLiu <liuyun01@kylinos.cn>
Cc: shli@fb.com, liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 02, 2016 at 05:02:39PM +0800, JackieLiu wrote:
> We can calculate this offset by using ctx->meta_total_blocks,
> without passing in from the function
> 
> Signed-off-by: JackieLiu <liuyun01@kylinos.cn>

Applied. Though this doesn't change any behavior, it does make the code a
little bit clean.
