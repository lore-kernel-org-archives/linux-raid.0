From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt again
Date: Fri, 13 Nov 2009 13:28:04 +1100
Message-ID: <19196.50228.743428.552300@notabene.brown>
References: <eyal@eyal.emu.id.au>
	<200911121920.nACJKDew011818@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from greg@enjellic.com on Thursday November 12
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday November 12, greg@enjellic.com wrote:
> 
> Neil/Martin what do you think?

I think that if you found out which blocks were different and mapped
that back through the filesystem, you would find that those blocks are
not a part of any file, or possibly are part of a file that is
currently being written.

I guess I need to start logging the error address so people can start
dealing with facts rather than fears.

NeilBrown
