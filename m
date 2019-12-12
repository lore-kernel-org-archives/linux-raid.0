From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH AUTOSEL 4.14 32/58] bcache: at least try to shrink 1 node in bch_mca_scan()
Date: Wed, 11 Dec 2019 22:48:35 -0500
Message-ID: <24049.47251.286105.88377@quad.stoffel.home>
References: <20191211152831.23507-1-sashal@kernel.org>
        <20191211152831.23507-32-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191211152831.23507-32-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Sasha" == Sasha Levin <sashal@kernel.org> writes:

Sasha> From: Coly Li <colyli@suse.de>
Sasha> [ Upstream commit 9fcc34b1a6dd4b8e5337e2b6ef45e428897eca6b ]

Sasha> In bch_mca_scan(), the number of shrinking btree node is calculated
Sasha> by code like this,
Sasha> 	unsigned long nr = sc->nr_to_scan;

Sasha>         nr /= c->btree_pages;
Sasha>         nr = min_t(unsigned long, nr, mca_can_free(c));
Sasha> variable sc->nr_to_scan is number of objects (here is bcache B+tree
Sasha> nodes' number) to shrink, and pointer variable sc is sent from memory
Sasha> management code as parametr of a callback.

Sasha> If sc->nr_to_scan is smaller than c->btree_pages, after the above
Sasha> calculation, variable 'nr' will be 0 and nothing will be shrunk. It is
Sasha> frequeently observed that only 1 or 2 is set to sc->nr_to_scan and make
Sasha> nr to be zero. Then bch_mca_scan() will do nothing more then acquiring
Sasha> and releasing mutex c->bucket_lock.

Sasha> This patch checkes whether nr is 0 after the above calculation, if 0
Sasha> is the result then set 1 to variable 'n'. Then at least bch_mca_scan()
Sasha> will try to shrink a single B+tree node.

Sasha>  	nr /= c->btree_pages;
Sasha> +	if (nr == 0)
Sasha> +		nr = 1;


Wouldn't it be even more clear with:

   nr /= c->bree_pages || 1;

instead?

John
