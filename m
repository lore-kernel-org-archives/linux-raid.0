From: Matt Callaghan <matt_callaghan@sympatico.ca>
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help
Date: Tue, 20 Jan 2015 19:34:02 -0500
Message-ID: <BLU436-SMTP1430CA88C11B0E46F15BB3F81480@phx.gbl>
References: <54ABEE54.6020707@sympatico.ca> <BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl> <BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl> <54B305B2.6000702@lentijn.sess.ink> <54B3F7ED.1000809@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54B3F7ED.1000809@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Wols and Valentijn for your input.

I tried again with the --bitmap=none, clearly that was a miss on my part.
However, still even with that correction, and attempting across varying 
combinations of "drive ordering", the filesystem appears corrupt.

I think I have to accept entire data loss here. :(

~Matt

-------- Original Message --------
From: Wols Lists <antlists@youngman.org.uk>
Sent: 1/12/2015, 11:35:57 AM
To: linux-raid@vger.kernel.org
Cc:
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help


> On 11/01/15 23:22, Valentijn Sessink wrote:
Also, I would not have dared to run all these statements on "live" (or
dead, for that matter ;-) disks.

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
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



