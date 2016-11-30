From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Reorganize make_request to clean up code.
Date: Wed, 30 Nov 2016 08:24:53 -0800
Message-ID: <20161130162453.GA19132@infradead.org>
References: <20161129230711.9987-1-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161129230711.9987-1-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 29, 2016 at 04:07:11PM -0700, Robert LeBlanc wrote:
> This code only runs during a write, so move it to the write section to
> clean up the code.
> 
> Signed-off-by: Robert LeBlanc <robert@leblancnet.us>

Can you please just split make_request into one function for reads
and one for writes?  There is no shared code at all, so this should be
much cleaner.
