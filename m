From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET 2.6.36-rc2] block, dm: finish REQ_FLUSH/FUA conversion
Date: Fri, 27 Aug 2010 19:15:05 +0200
Message-ID: <4C77F299.4080004__11716.8956589468$1282929695$gmane$org@kernel.org>
References: <1282929060-23663-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1282929060-23663-1-git-send-email-tj@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vge
List-Id: linux-raid.ids

On 08/27/2010 07:10 PM, Tejun Heo wrote:
> The dm conversion is _lightly_ tested.  Please proceed with caution.
> In particular, I haven't tested dm implementation at all.
                                  ^^
				 requested-based dm

-- 
tejun
