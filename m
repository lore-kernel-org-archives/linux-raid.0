From: Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH][RESEND] managemon: Don't add disk to the array after it
 has started
Date: Thu, 7 Dec 2017 09:20:35 -0500
Message-ID: <40585df8-a529-455e-d4bb-bcb194394416@fb.com>
References: <1510579012-3909-1-git-send-email-tomasz.majchrzak@intel.com>
 <1512638634-12436-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1512638634-12436-1-git-send-email-tomasz.majchrzak@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/07/2017 04:23 AM, Tomasz Majchrzak wrote:
> If disk has disappeared from the system and appears again, it is added to the
> corresponding container as long the metadata matches and disk number is set.
> This code had no effect on imsm until commit 20dc76d15b40 ("imsm: Set disk slot
> number"). Now the disk is added to container but not to the array - it is
> correct as the disk is out-of-sync. Rebuild should start for the disk but it
> doesn't. There is the same behaviour for both imsm and ddf metadata.
> 
> There is no point to handle out-of-sync disk as "good member of array" so
> remove that part of code. There are no scenarios when monitor is already
> running and disk can be safely added to the array. Just write initial metadata
> to the disk so it's taken for rebuild.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>

Applied!

Thanks,
Jes


