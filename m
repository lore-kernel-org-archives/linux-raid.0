From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: ANNOUNCE: mdadm 1.8.0 - A tool for managing Soft RAID under
 Linux
Date: Sun, 28 Nov 2004 21:01:24 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411282059360.19614@adsl.a2000.nu>
References: <16775.316.540974.984718@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16775.316.540974.984718@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2 Nov 2004, Neil Brown wrote:

> as a source tar-ball and (at the first site) as an SRPM,
> and as an RPM for i386.

Neil,

today i tried to rebuild the src.rpm from 1.8 (which is the latest stable 
release?)

but i got this error :

]# rpmbuild --rebuild /tmp/mdadm-1.8.1-1.src.rpm
Installing /tmp/mdadm-1.8.1-1.src.rpm
warning: user neilb does not exist - using root
warning: group neilb does not exist - using root
warning: user neilb does not exist - using root
warning: group neilb does not exist - using root
error: line 54: second %install

i fixed the mdadm.spec file, and it compiled ok
(removed the % on line 54)

maybe fix this in later releases ?

(i was compiling this on tao (based on rhes 3))
