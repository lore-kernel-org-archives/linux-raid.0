From: Phil Turmel <philip@turmel.org>
Subject: Re: [PATCH] md: register new md sysfs file 'uuid' read-only
Date: Mon, 08 Oct 2012 13:50:53 -0400
Message-ID: <5073127D.7070500@turmel.org>
References: <1349185330-9024-1-git-send-email-sebastian.riemer@profitbricks.com> <20121003083031.51093f0c@notabene.brown> <50730010.5090605@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50730010.5090605@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/08/2012 12:32 PM, Sebastian Riemer wrote:> Hi Neil,
>
> I must have overseen your answer. We want to use as less mdadm as
> possible - especially for simple checking stuff. The kernel knows best.
> "mdadm -D" reads the data from disk. This means additional disk access.
> It is also possible that this command triggers superblock updates.
> Simple checking stuff shouldn't have to use disk access.
>
> We are planning to use MD RAID a little bit different with e.g. 100 MD
> arrays. Searching for a particular UUID in this bunch of MD devices can
> be difficult without this patch. This is how the kernel represents
> UUIDs. Conversion can be done in user space.
>
> If you like it better in the xxxxxxxx:xxxxxxxx:xxxxxxxx:xxxxxxxx format,
> I can resend the patch in that format.

If you are aiming for consistency, the dm driver(s) have already
established a no-punctuation format for the UUID itself (punctuation
separates UUID type from the UUID) within sysfs.

Regards,

Phil
