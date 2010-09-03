From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/5] dm: relax ordering of bio-based flush implementation
Date: Fri, 03 Sep 2010 11:42:53 +0200
Message-ID: <4C80C31D.5020906@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-4-git-send-email-tj@kernel.org> <4C808FF4.4010901@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C808FF4.4010901@ct.jp.nec.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jaxboe@fusionio.com, snitzer@redhat.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

Hello,

On 09/03/2010 08:04 AM, Kiyoshi Ueda wrote:
> Now queue_io() is called from dec_pending(), which may be called with
> interrupts disabled.
> So queue_io() must not enable interrupts unconditionally and must
> save/restore the current interrupts status.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Patch included into the series.  Thanks a lot!

-- 
tejun
