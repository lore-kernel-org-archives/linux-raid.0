From: Chris Mason <clm@fb.com>
Subject: Re: [RFC v2 2/2] fs: btrfs: Extends btrfs/raid56 to support up to
 six parities
Date: Mon, 6 Jan 2014 14:12:56 +0000
Message-ID: <1389017609.23310.0.camel@ret.masoncoding.com>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
	 <1389000716-3274-3-git-send-email-amadvance@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389000716-3274-3-git-send-email-amadvance@gmail.com>
Content-Language: en-US
Content-ID: <03D3FBCD996DF84691383E1810360F94@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "amadvance@gmail.com" <amadvance@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, "neilb@suse.de" <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2014-01-06 at 10:31 +-0100, Andrea Mazzoleni wrote:
+AD4- This patch changes btrfs/raid56.c to use the new raid interface and
+AD4- extends its support to an arbitrary number of parities.
+AD4- 
+AD4- More in details, the two faila/failb failure indexes are now replaced
+AD4- with a fail+AFsAXQ- vector that keeps track of up to six failures, and now
+AD4- the new raid+AF8-par() and raid+AF8-rec() functions are used to handle with
+AD4- parity instead of the old xor/raid6 ones.
+AD4- 

Neat.  The faila/failb were always my least favorite part of the btrfs
code +ADs-)  Did you test just raid5/6 or also the higher parity counts?

-chris
