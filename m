From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: "Enhanced" MD code avaible for review
Date: Thu, 18 Mar 2004 01:56:52 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040318015652.GD31500@parcelfarce.linux.theplanet.co.uk>
References: <459805408.1079547261@aslan.scsiguy.com> <4058A481.3020505@pobox.com> <4058C089.9060603@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4058C089.9060603@adaptec.com>
To: Scott Long <scott_long@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org, "Gibbs, Justin" <justin_gibbs@adaptec.com>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 17, 2004 at 02:18:01PM -0700, Scott Long wrote:
> >One overall comment on merging into 2.6:  the patch will need to be
> >broken up into pieces.  It's OK if each piece is dependent on the prior
> >one, and it's OK if there are 20, 30, even 100 pieces.  It helps a lot
> >for review to see the evolution, and it also helps flush out problems
> >you might not have even noticed.  e.g.
> >        - add concept of member, and related helper functions
> >        - use member functions/structs in raid drivers raid0.c, etc.
> >        - fix raid0 transform
> >        - add ioctls needed in order for DDF to be useful
> >        - add DDF format
> >        etc.
> >
> 
> We can provide our Perforce changelogs (just like we do for SCSI).

TA: "you must submit a solution, not just an answer"
CALC101 student: "but I've checked the answer, it's OK"
TA: "I'm sorry, it's not enough"
<student hands a pile of paper covered with snippets of text and calculations>
Student: "All right, here are all notes I've made while solving the problem.
Happy now?"
TA: <exasperated sigh> "Not really"
