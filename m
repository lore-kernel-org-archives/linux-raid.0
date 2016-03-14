From: Christoph Hellwig <hch@infradead.org>
Subject: Re: multipath: I/O hanging forever
Date: Mon, 14 Mar 2016 00:41:50 -0700
Message-ID: <20160314074150.GA29046@infradead.org>
References: <20160229015333.GA3101@Dell>
 <20160229034616.GA2682@Dell>
 <20160304173044.GA2636@Dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160304173044.GA2636@Dell>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Just curious: why are you using the old MD multipath driver that's
been depcrecated in favor of DM multipath a long time ago?
