From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
      needed.
Date: Mon, 24 Nov 2008 15:12:53 +0900
Message-ID: <492A45E5.9010003@kernel.org>
References: <20081124035516.3465.66413.stgit@notabene.brown>    <20081124035530.3465.26724.stgit@notabene.brown>    <492A2B2B.7030606@kernel.org>    <18730.14324.830648.449469@notabene.brown>    <492A3CE6.4010206@kernel.org> <ca37dc6598bb5728423fd902ac5322f9.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ca37dc6598bb5728423fd902ac5322f9.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

NeilBrown wrote:
> Note that we already have 'release' in block_device_operations.  It is
> called on last close rather than last put.

Aieee... right.  How about release_disk() or disk_release()?

-- 
tejun
