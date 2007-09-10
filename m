From: Dimitrios Apostolou <jimis@gmx.net>
Subject: Re: RAID1 and load-balancing during read
Date: Mon, 10 Sep 2007 22:51:37 +0300
Message-ID: <200709102251.37976.jimis@gmx.net>
References: <200709102229.30655.jimis@gmx.net> <20070910193530.GB2597@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070910193530.GB2597@teal.hq.k1024.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Iustin Pop <iusty@k1024.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 10 September 2007 22:35:30 Iustin Pop wrote:
> On Mon, Sep 10, 2007 at 10:29:30PM +0300, Dimitrios Apostolou wrote:
> > Hello list,
> >
> > I just created a RAID1 array consisting of two disks. After experiments
> > with processes *reading* from the device (badblocks, dd) and the iostat
> > program, I can see that only one disk is being utilised for reading. To
> > be exact, every time I execute the command one of the two disks is being
> > randomly used, but the other one has absolutely no activity.
> >
> > My question is: why isn't load balancing happening? Is there an option
> > I'm missing? Until now I though it was the default for all RAID1
> > implementations.
>
> Did you read the archives of this list? This question has been answered,
> like, 4 times already in the last months.
>
> And yes, the driver does do load balancing. Just not as RAID0 does,
> since it's not RAID0.

Of course I did a quick search in the archives but couldn't find anything. 
I'll search better, thanks anyway. Moreover, I think I found the answer in 
the code after posting. There is a comment somewhere in read_balance() 
saying "Don't change to another disk for sequential reads". I have to study 
it a bit to figure out *why* you chose that way. 


Thanks, 
Dimitris
