From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 2 May 2008 07:13:45 -0700 (PDT)
Message-ID: <271684.86609.qm@web50210.mail.re2.yahoo.com>
References: <481B1A7D.2020000@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <481B1A7D.2020000@aitel.hist.no>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>, Kasper Sandberg <lkml@metanurb.dk>, Helge Hafting <helge.hafting@aitel.hist.no>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> > > Can you explain what you mean, exactly?
> > As an example, you have disks /dev/sd[abc]. /dev/md0 would be made 
> > from /dev/sda1, /dev/sdb1, and /dev/sdc1; /dev/md1 would be made
> > from /dev/sda2, /dev/sdb2, and /dev/sdc2.

> I've been watching this thread with interest, because I wanted
> clarification on what the OP meant.

> If by "sharing disks", the OP meant the above, I'm surprised (and
>  concerned) there's any question at all.  How is this anything other    > than the definition of "mirror"? 
md0 and md1 are both RAID 5 arrays, not mirrors.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
