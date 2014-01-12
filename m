From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Sun, 12 Jan 2014 12:27:42 -0700
Message-ID: <B3B27904-3094-45D0-A975-78659B9EA36A@colorremedies.com>
References: <38C8AAEB-811B-442F-BA80-1EFAF00BADB1@colorremedies.com> <6AACF77C-5D54-4ABF-AA2D-FC3F4F1E141C@colorremedies.com> <yq1txd9nw2d.fsf@sermon.lab.mkp.net> <F92ECEC1-D375-498B-8C6A-C88C815C325F@colorremedies.com> <yq1lhylnj8z.fsf@sermon.lab.mkp.net> <B202E185-81A8-4F10-A311-521F2E7086BA@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B202E185-81A8-4F10-A311-521F2E7086BA@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids


On Jan 12, 2014, at 12:04 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Is there even a single GPT partitioning tool that doesn't align to at least 8-sector boundaries? So far every one of these drives in enclosures is sufficiently large that they're going to be GPT partitioned in any case.

Another use case that explains this better than RMW avoidance, even though I still think it's a junk workflow: a single product that can be used from Windows XP 32-bit all the way to the most recent OS's, with no tricks like jumpers or specialized formatting tools.

If the manufacturer uses 4096 byte logical sectors, they can format the disk using MBR. With 4K sector sizes, MBR will support a 16TB drive.

I think this is more useful for the manufacturers with this product class, than is RMW avoidance, although such RMW avoidance is an included side benefit. It makes me wonder why we haven't seen more of these in the wild. It seems the enclosure case should be glued instead of screwed, with a warranty voided if cracked sticker to deter removal.

Chris Murphy

