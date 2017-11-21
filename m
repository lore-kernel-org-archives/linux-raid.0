From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Monitor/msg: Don't print error message if mdmon doesn't
 run
Date: Tue, 21 Nov 2017 13:26:25 -0500
Message-ID: <a47cf2c2-664e-b05b-6df2-80f17cc7eb7f@gmail.com>
References: <1511260220-26759-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1511260220-26759-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/21/2017 05:30 AM, Mariusz Tkaczyk wrote:
> Commit 4515fb28a53a ("Add detail information when can not connect
> monitor") was added to warn about failed connection to monitor in 
> WaitClean function (see link below).
> 
> Mdmon runs for IMSM containers when they have array with redundancy so
> if mdmon doesn't run, mdadm prints this error. This is misleading and
> unnecessary. Just print it in WaitClean function.
> 
> The sock in WaitClean is deprecated so it is removed.
> 
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1375002
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>

Applied!

Thanks,
Jes


