From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Date: Mon, 23 Aug 2010 13:01:09 -0700
Message-ID: <20100823130109.6da43a58.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
	<20100823122606.47524cef.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hows about you add a helper function

	void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)

then convert the callsites to use that, then nuke __GFP_NOFAIL?
