From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: SATA performace
Date: Mon, 2 Jan 2006 23:47:59 -0500
Message-ID: <20060103044759.GA8876@lug.udel.edu>
References: <17336.42843.779496.644030@smtp.charter.net> <000d01c61017$ea630d10$3224050a@avilespaxp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000d01c61017$ea630d10$3224050a@avilespaxp>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Aviles <paul.aviles@palei.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 02, 2006 at 10:43:47PM -0500, Paul Aviles wrote:
> Are SATA drives similar in performance than IDE drives? I have tested 
> Barracudas 7200.0 (500Gb) and WD too on the same type of servers (more than 
> 1 unit) and what I am getting is painfully slow in terms of read/writes. 
> Anyone out there with similar experience or this is just my isolated 
> results?

Probably depends on your controller and configuration.  If it's an
integrated controller, boot into your BIOS and make sure that any kind
of "Native/Legacy Mode" option is set to "Native mode".

I don't know what the difference is, but I've seen Legacy mode boxes
crawl...

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
