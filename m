From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm and --program
Date: Sat, 5 Oct 2002 10:12:55 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15774.11911.898783.603341@notabene.cse.unsw.edu.au>
References: <200210031601.35139.jbyrkit@pcpao.org>
	<20021003205948.EC0F43B828@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Derek Vadala on Thursday October 3
To: Derek Vadala <derek@cynicism.com>
Cc: Jeff Byrkit <jbyrkit@pcpao.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 3, derek@cynicism.com wrote:
> You could alternatively use:
> 
> # mdadm --follow --program='/bin/bash /etc/handle-mdadm-events' --delay=1 /dev/md0
> 

This would only work if '/bin/bash /etc/handle-mdadm-events' was a
program.
i.e. if 'handle-mdadm-events' were a file in the directory 'etc' in
the directory 'bash ' in the directory 'bin'.  Which is unlikely.

NeilBrown
