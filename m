From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 21 Mar 2005 16:32:47 -0500
Message-ID: <200503212132.j2LLWrT07466@www.watkins-home.com>
References: <qbo3h2-kjo.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <qbo3h2-kjo.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Say you have 2 systems, "A" and "B".

"A" is active, a network failure occurs, node "A" can't talk to "B" or the
clients.  The remote member of the array is failed.  But "A" is still
running, and maybe in the process of shutting down.  The process of shutting
down "A" will cause more writes to the disk.  Even without a proper
shutdown, disk writes can occur, cron jobs, log files, whatever, all
occurring before the shutdown, or power off.

At some point node "B" becomes active, and processes live data.  Now,
someone fixes the problem and you want to re-sync.  Both "A" and "B" have
done disk I/O that the other does not know about.  Both bitmap must be used
to re-sync, or a 100% re-sync must be done.

I think what I have outlined above is quite reasonable.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter T. Breuer
Sent: Monday, March 21, 2005 3:45 PM
To: linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/2] md bitmap bug fixes

Paul Clements <paul.clements@steeleye.com> wrote:
> At any rate, this is all irrelevant given the second part of that email 
> reply that I gave. You still have to do the bitmap combining, regardless 
> of whether two systems were active at the same time or not.

As I understand it, you want both bitmaps in order to make sure that on
resync you wipe over whatever may have been accidentally dirtied on the
other side by a clumsy admin or vicious gremlin (various guises -
software bug, journal effects, design incompetency, etc.).

Writing everything across (and ignoring the bitmap) would do the trick,
but given that we are being efficient and using bitmaps to lower the
write totals at resync time, we need to use both bitmaps so as not to
miss out on overwriting anything we should be overwriting.

But why don't we already know from the _single_ bitmap on the array
node ("the node with the array") what to rewrite in total? All writes
must go through the array. We know how many didn't go to both
components. Thus we know how many to rewrite from the survivor to the
component that we lost contact with.

Might some of the writes we don't think made it to the faulty component
actually have made it?  Sure.  But so what?  On resync we will rewrite
them because we don't think they made it.

Puzzling!

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

