From: Brice Figureau <brice+lklm@daysofwonder.com>
Subject: Re: Same UUID for every member of all array ?
Date: Fri, 13 Apr 2007 14:44:54 +0200
Message-ID: <1176468294.25857.31.camel@localhost.localdomain>
References: <1176382677.14496.17.camel@localhost.localdomain>
	 <20070413073228.GA15415@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070413073228.GA15415@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Iustin Pop <iusty@k1024.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thanks for the answer,

On Fri, 2007-04-13 at 09:32 +0200, Iustin Pop wrote:
> On Thu, Apr 12, 2007 at 02:57:57PM +0200, Brice Figureau wrote:
> > Now, I don't know why all the UUID are equals (my other machines are not
> > affected).
> I think at some point either in sarge or in testing between sarge and
> etch, there was included a version of mdadm which had this bug (all
> arrays had the same uuid). Yeah, it bit me too a little :)

I wasn't aware of the issue - guess I should have noticed that issue
when creating the arrays first.

After searching, the problem appeared because Debian packaged mdadm
version 1.8.1 which wasn't stable. 
Here is one of the debian bug report:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=290363

> > Is there a possibility to "hot" change the UUID of each array (and
> > change the corresponding superblocks of each member) so that my next
> > boot will work ?
> did you read the manpage for mdadm (the version in etch)? It has a -U
> argument to assemble which does what you want.

Yes, I read it (and now twice :-)). 

The problem is that right now the server is up and running (booting with
an old kernel without initrd starts the arrays without any issue, that's
strange), so I can't change the UUID (as it has to be done while
assembling the array).

I first need to reboot with an initrd kernel that fails to assemble the
root array, and issue the mdadm assemble by hand. To do that I must be
physically in front of the console. And this will incur downtime for the
users of this particular server, hence my question about "hot" changing
the UUID...

Anyway, many thanks for your help,
-- 
Brice Figureau <brice+lklm@daysofwonder.com>

