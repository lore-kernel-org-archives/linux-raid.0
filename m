From: likewhoa <likewhoa@weboperative.com>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Fri, 27 Apr 2012 22:37:29 -0400
Message-ID: <4F9B57E9.2060409@weboperative.com>
References: <4F9AFBC6.7070803@weboperative.com> <4F9B14FA.1090001@weboperative.com> <20120428080522.637bc564@notabene.brown> <4F9B2BE1.5080207@weboperative.com> <4F9B3B48.8020900@weboperative.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9B3B48.8020900@weboperative.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/27/2012 08:35 PM, likewhoa wrote:
> I am not sure how to proceed now with the output that shows possible
> pairs as it won't allow me to setup all 8 devices on the array but only
> 4. Should I run the array creation with -x4 and set the available spare
> devicesor or just create the array as I can remember which was one pair
> from each controller. i.e /dev/sda3 /dev/sde3 ...?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ok I was able to recreate the array with correct order which I took from
my /dev/md0's --details output and was able to decrypt the luks mapping
but XFS didn't open and xfs_repair is currently doing the matrix. I will
keep this posted with updates.

Thanks again Neil.
WRT 3.3.3 should I just go back to 3.3.2 which seemed to run fine and
wait until there is a release of 3.3.3 that has fix?

