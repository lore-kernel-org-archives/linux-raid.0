From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Problem with Openmosix
Date: Tue, 15 Feb 2005 09:10:45 +1100
Message-ID: <16913.8677.140703.150612@cse.unsw.edu.au>
References: <1108417972.2873.9.camel@next3.aprosi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Joaquin Ferrero on Monday February 14
Sender: linux-raid-owner@vger.kernel.org
To: Joaquin Ferrero <explorer@aprosi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 14, explorer@aprosi.net wrote:
> Hi, Neil...

Hi.

> 
> I use MD driver two year ago with Debian, and run perfectly.

Great!

> 
> The machine boot the new kernel a run Ok... but... if I (or another
> process) make a change/write to the raid md system, the computer crash
> with the message:
> 
> 	hdh: Drive not ready for command.
> 
> (hdh is the mirror raid1 for hdf disk).

I cannot help thinking that maybe the Drive is not ready for the
command.  i.e. it isn't an md problem.  It isn't an openmosix
problem.  It is a drive hardware problem, or maybe an IDE controller
problem.   Can you try a different drive? Can you try just putting a
filesystem on that drive alone and see if it works?

NeilBrown
