From: Luca Berra <bluca@comedia.it>
Subject: Re: problems with raid=noautodetect
Date: Fri, 26 May 2006 09:53:08 +0200
Message-ID: <20060526075308.GC8203@percy.comedia.it>
References: <4471B188.3060400@umit.at> <17522.15774.526526.244768@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17522.15774.526526.244768@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 23, 2006 at 08:39:26AM +1000, Neil Brown wrote:
>Presumably you have a 'DEVICE' line in mdadm.conf too?  What is it.
>My first guess is that it isn't listing /dev/sdd? somehow.

Neil,
i am seeing a lot of people that fall in this same error, and i would
propose a way of avoiding this problem

1) make "DEVICE partitions" the default if no device line is specified.
2) deprecate the "DEVICE" keyword issuing a warning when it is found in
the configuration file
3) introduce "DEVICEFILTER" or similar keyword with the same meaning at
the actual "DEVICE" keyboard
4) optionally add an "EXCLUDEDEVICE" keyword with the opposite meaning.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
