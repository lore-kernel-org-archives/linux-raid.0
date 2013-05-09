From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH] bcache: Fix incompatible pointer type warning
Date: Thu, 9 May 2013 13:57:01 -0700
Message-ID: <20130509205701.GC15040@moria.home.lan>
References: <1368131966-17512-1-git-send-email-emilgoode@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368131966-17512-1-git-send-email-emilgoode@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Emil Goode <emilgoode@gmail.com>
Cc: neilb@suse.de, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 09, 2013 at 10:39:26PM +0200, Emil Goode wrote:
> The function pointer release in struct block_device_operations
> should point to functions declared as void.

Looks like .release just changed to returning void in the merge window -
thanks, applied
