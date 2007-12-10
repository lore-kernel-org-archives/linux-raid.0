From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH 003 of 3] md: Update md bitmap during resync.
Date: Mon, 10 Dec 2007 15:04:14 -0500
Message-ID: <170fa0d20712101204u7add338ah5d05d4d2501432d6@mail.gmail.com>
References: <20071207163806.7539.patches@notabene> <1071207054200.7907@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_18091_21201694.1197317054351"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1071207054200.7907@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_18091_21201694.1197317054351
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Dec 7, 2007 12:42 AM, NeilBrown <neilb@suse.de> wrote:
>
> Currently and md array with a write-intent bitmap does not updated
> that bitmap to reflect successful partial resync.  Rather the entire
> bitmap is updated when the resync completes.
>
> This is because there is no guarentee that resync requests will
> complete in order, and tracking each request individually is
> unnecessarily burdensome.
>
> However there is value in regularly updating the bitmap, so add code
> to periodically pause while all pending sync requests complete, then
> update the bitmap.  Doing this only every few seconds (the same as the
> bitmap update time) does not notciably affect resync performance.
>
> Signed-off-by: Neil Brown <neilb@suse.de>

Hi Neil,

You forgot to export bitmap_cond_end_sync.  Please see the attached patch.

regards,
Mike

------=_Part_18091_21201694.1197317054351
Content-Type: text/x-patch; name=export_bitmap_cond_end_sync.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fa1fkr4p0
Content-Disposition: attachment; filename=export_bitmap_cond_end_sync.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYml0bWFwLmMgYi9kcml2ZXJzL21kL2JpdG1hcC5jCmlu
ZGV4IGYzMWVhNGYuLmI1OTY1MzggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvYml0bWFwLmMKKysr
IGIvZHJpdmVycy9tZC9iaXRtYXAuYwpAQCAtMTU2NiwzICsxNTY2LDQgQEAgRVhQT1JUX1NZTUJP
TChiaXRtYXBfc3RhcnRfc3luYyk7CiBFWFBPUlRfU1lNQk9MKGJpdG1hcF9lbmRfc3luYyk7CiBF
WFBPUlRfU1lNQk9MKGJpdG1hcF91bnBsdWcpOwogRVhQT1JUX1NZTUJPTChiaXRtYXBfY2xvc2Vf
c3luYyk7CitFWFBPUlRfU1lNQk9MKGJpdG1hcF9jb25kX2VuZF9zeW5jKTsK
------=_Part_18091_21201694.1197317054351--
