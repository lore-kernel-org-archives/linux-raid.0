From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: accessing mirrired lvm on shared storage
Date: Thu, 13 Apr 2006 10:57:02 -0400
Message-ID: <170fa0d20604130757s22407500ude1bcc16d499273@mail.gmail.com>
References: <44355BC9.4020608@mailing.kaufland-informationssysteme.com>
	 <20060407134636.2bce1917@mwdsp001>
	 <17468.32144.316047.478627@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17468.32144.316047.478627@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Chris Osicki <osk@admin.swisscom-mobile.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/12/06, Neil Brown <neilb@suse.de> wrote:

> One thing that is on my todo list is supporting shared raid1, so that
> several nodes in the cluster can assemble the same raid1 and access it
> - providing that the clients all do proper mutual exclusion as
> e.g. OCFS does.

Very cool... that would be extremely nice to have.  Any estimate on
when you might get to this?

Mike
