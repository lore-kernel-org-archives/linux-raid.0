From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch] md/raid0: check for create_strip_zones() errors
Date: Wed, 13 Apr 2016 10:02:40 -0700
Message-ID: <20160413170240.GB6186@kernel.org>
References: <20160413064645.GH8092@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413064645.GH8092@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Krzysztof Wojcik <krzysztof.wojcik@intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 13, 2016 at 09:46:45AM +0300, Dan Carpenter wrote:
> My static checker complains that if create_strip_zones() fails then we
> use "priv_conf" without initializing it.  Fix this by checking for
> failure.

It's more convenient setting '*private_conf = ERR_PTR(-ENOMEM);' at the
begining of create_strip_zones() when it returns -ENOMEM. create_strip_zones
already sets private_conf correctly in other cases.

Thanks,
Shaohua
