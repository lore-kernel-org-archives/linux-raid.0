From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 001 of 2] Close a small race in md thread
 deregistration
Date: Fri, 8 Apr 2005 12:20:02 +1000
Message-ID: <16981.59986.334701.18743@cse.unsw.edu.au>
References: <20050408113719.27541.patches@notabene>
	<E1DJiVG-0007B6-Bd@notabene.cse.unsw.edu.au>
	<20050407191421.31b26d3e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday April 7
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 7, akpm@osdl.org wrote:
> 
> That code all seems a bit crufty to me.  Sometime it would be good to stop
> using signals in-kernel and to use the kthread API for thread startup and
> shutdown.

I've just added that to my TODO list... thanks for the suggestion.

NeilBrown
