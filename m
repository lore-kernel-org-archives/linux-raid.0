From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 005 of 11] md: Merge raid5 and raid6 code
Date: Sun, 30 Apr 2006 22:40:05 -0700
Message-ID: <44559F35.2050800@zytor.com>
References: <20060501152229.18367.patches@notabene> <1060501053025.22961@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060501053025.22961@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> There is a lot of commonality between raid5.c and raid6main.c.  This
> patches merges both into one module called raid456.  This saves a lot
> of code, and paves the way for online raid5->raid6 migrations.
> 
> There is still duplication, e.g. between handle_stripe5 and
> handle_stripe6.  This will probably be cleaned up later.
> 
> Cc:  "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 

Wonderful!  Thank you for doing this :)

	-hpa
