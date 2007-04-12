From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH RFC 3/4] md: writeback caching policy for raid5 [experimental]
Date: Thu, 12 Apr 2007 08:37:43 +0300
Message-ID: <200704120837.43898.a1426z@gawab.com>
References: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com> <20070411060036.15745.7016.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070411060036.15745.7016.stgit@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
> In write-through mode bi_end_io is called once writes to the data disk(s)
> and the parity disk have completed.
>
> In write-back mode bi_end_io is called immediately after data has been
> copied into the stripe cache, which also causes the stripe to be marked
> dirty.

This is not really meaningful, as this is exactly what the page-cache already 
does before being synced.

It may be more reasonable to sync the data-stripe as usual, and only delay 
the parity.  This way you shouldn't have to worry about unclean shutdowns.


Thanks!

--
Al

