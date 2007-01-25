From: Neil Brown <neilb@suse.de>
Subject: Re: There is an advice
Date: Thu, 25 Jan 2007 14:01:49 +1100
Message-ID: <17848.7581.376785.375291@notabene.brown>
References: <200701051611098594960@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from liyiming on Friday January 5
Sender: linux-raid-owner@vger.kernel.org
To: liyiming <liyiming@nrchpc.ac.cn>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday January 5, liyiming@nrchpc.ac.cn wrote:
> In the stop function of any level raid device driver such as faulty, multipath, and raidx
> It would better set the mddev->private NULL before free the conf structure. 

We set it to NULL immediately after the free, and it really doesn't
make any different which order they are done in.

NeilBrown
