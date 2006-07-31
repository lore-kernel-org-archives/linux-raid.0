From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 006 of 9] md: Remove the working_disks and failed_disks
 from raid5 state data.
Date: Mon, 31 Jul 2006 11:43:28 +0400
Message-ID: <44CDB4A0.5010805@tls.msk.ru>
References: <20060731172842.24323.patches@notabene> <1060731073227.24494@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060731073227.24494@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> They are not needed.
> conf->failed_disks is the same as mddev->degraded

By the way, `failed_disks' is more understandable than `degraded'
in this context.  "Degraded" usually refers to the state of the
array in question, when failed_disks > 0.

That to say: I'd rename degraded back to failed_disks, here and
in the rest of raid drivers... ;)

/mjt
