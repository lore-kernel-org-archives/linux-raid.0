From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: help! how do I mark spare drive as active without reconstruct?
Date: Fri, 12 Sep 2003 15:17:24 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16225.22244.132454.180117@notabene.cse.unsw.edu.au>
References: <Pine.GSO.4.33.0309102227050.4844-100000@usny54.ixs1.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Welch on Wednesday September 10
To: Bill Welch <billw@ewaydirect.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 10, billw@ewaydirect.com wrote:
> repost with different subject, previous subject line suggested this was an
> answer, not a question.
> 
> I have a drive marked as spare that I know is a synced member of a raid5.
> I want to add it back into the array *without* a reconstruct, i.e. just
> mark it as active and change it's position.

You can't.
You don't want to.
The time you have spent waiting for a reply, you could have more
productively spent waiting for the resync to complete.  It probably
would have completed by now.

(Well, actually you can by changing about 1 line in mdadm and
re-creating the array, but I'm not going to tell you which line
because I really don't think you want to do it.
I think mkraid has an option that lets you do this, and I don't
recommend mkraid, and if you figure out how to do it, and do it, and
you loose you data, then just remember that I told you that you didn't
want to, and I apologise for telling you about mkraid...)


NeilBrown
