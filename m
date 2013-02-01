From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Raid 5 to 6 migration
Date: Fri, 1 Feb 2013 11:49:19 -0700
Message-ID: <065BDBBE-7DB8-40CC-B1BC-8DCEE327F7C4@colorremedies.com>
References: <BLU0-SMTP433B0BCF64D448CC81098D2C91C0@phx.gbl> <510C0075.9010908@turmel.org> <20130202001625.2b7d6514@natsu> <510C072B.1030108@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510C072B.1030108@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 1, 2013, at 11:19 AM, Phil Turmel <philip@turmel.org> wrote:

> On 02/01/2013 01:16 PM, Roman Mamedov wrote:
>> 
>> --layout=preserve will make it an order of magnitude faster. Read "man mdadm"
>> for more details. (And "man md" to learn about things in general.)
> 
> But will leave the array "unbalanced"--the 7th drive will never be used
> for reads in normal (non-degraded) operation--reducing read performance.

Does this option mean, in effect, the 7th disk is just a parity disk? So, sorta like a hybrid RAID 5/RAID4.


Chris Murphy

