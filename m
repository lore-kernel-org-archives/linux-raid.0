From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help
Date: Mon, 12 Jan 2015 16:35:57 +0000
Message-ID: <54B3F7ED.1000809@youngman.org.uk>
References: <54ABEE54.6020707@sympatico.ca> <BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl> <BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl> <54B305B2.6000702@lentijn.sess.ink>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54B305B2.6000702@lentijn.sess.ink>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/01/15 23:22, Valentijn Sessink wrote:
> Also, I would not have dared to run all these statements on "live" (or
> dead, for that matter ;-) disks.

I'm no expert either, but looking at the blog, I'm worried he might have
trashed the array with almost the first thing he did :-(

"add" says it will add a drive as spare if it didn't originally belong
to the array. If it adds a spare to a degraded array, the array will
immediately start to repair itself.

OOPS!!! As it sounds like exactly this could have happened - mdadm
didn't recognise the disk as it added it.

Just speculating, but unfortunately this seems quite likely :-(

Cheers,
Wol
