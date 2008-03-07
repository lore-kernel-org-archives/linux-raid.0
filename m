From: Neil Brown <neilb@suse.de>
Subject: Re: equal size not large enough for RAID1?
Date: Fri, 7 Mar 2008 14:43:51 +1100
Message-ID: <18384.47607.709703.403641@notabene.brown>
References: <20080305100547.2634bd04.taeuber@bbaw.de>
	<18383.24086.165437.659336@notabene.brown>
	<20080306101157.52d482b3.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lars Tauber on Thursday March 6
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 6, taeuber@bbaw.de wrote:
> 
> What is this internal bitmap good for? Is there a documentation
> somewhere on the net about this? 

  man md
and search for BITMAP.  There is a section of BITMAP WRITE-INTENT
LOGGING.

> 
> I just repeated the following:
> 
> monosan:~ # mdadm -C /dev/md9 -l1 -n2 -x0 /dev/md4 /dev/etherd/e22.0 
> mdadm: Defaulting to verion 1.0 metadata
> mdadm: /dev/md4 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Thu Mar  6 09:39:37 2008
> mdadm: /dev/etherd/e22.0 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Thu Mar  6 09:39:37 2008
> Continue creating array? y
> mdadm: array /dev/md9 started.
> 
> monosan:~ # mdadm -V
> mdadm - v2.6.2 - 21st May 2007
> 
> monosan:~ # mdadm /dev/md9 -f /dev/etherd/e22.0 
> mdadm: set /dev/etherd/e22.0 faulty in /dev/md9
> 
> monosan:~ # mdadm /dev/md9 -r /dev/etherd/e22.0 
> mdadm: hot removed /dev/etherd/e22.0
> 
> monosan:~ # mdadm /dev/md9 -a /dev/etherd/e22.0 
> mdadm: /dev/etherd/e22.0 not large enough to join array

Hmm..  I just read through the change logs and I see there was a bug
here that was fixed in 2.6.3.
If you want an update from SuSE you would need to log a bug report in
the Novell bugzilla.

Alternately request v0.90 metadata (--metadata=0.90)  That will avoid
the bug.

NeilBrown
