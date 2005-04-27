From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] secure write for RAID1
Date: Wed, 27 Apr 2005 13:26:08 +0200
Message-ID: <20050427112608.GB19485@percy.comedia.it>
References: <1toqj2-sjd.ln1@news.it.uc3m.es> <17007.1524.476174.515614@cse.unsw.edu.au> <20050427060531.GH4431@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050427060531.GH4431@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 27, 2005 at 08:05:31AM +0200, Lars Marowsky-Bree wrote:
>On 2005-04-27T13:24:36, Neil Brown <neilb@cse.unsw.edu.au> wrote:
>
>> On Saturday April 23, ptb@lab.it.uc3m.es wrote:
>> > This patch (completely untested of course - what, me?) makes RAID1 write
>> > to all components of a raid-1 array, else return error to the write
>> > attempt, when one component cannot be written.
>> I don't understand why or when you would want this.
>> 
>> This wouldn't just return an error to the application if the write
>> wasn't completely safe.  It would cause the filesystem to switch to
>> read-only very quickly and make your machine un-usable.  Is that
>> really what you want??
>
>Databases sometimes want this (also for replication).
>
>They'd rather fail than potentially lose a committed transaction, and to
>that end they require that the data be written to at least two disks; ie
>they want the data to be able to withstand at least one failure.  We've
>had such a request from a big database vendor for drbd too.

yes, if it were possible to return the failure to the application it
would be great. if it is not, in such "corner" cases it is better to
have an app fail than to promise it has committed a replicated
transaction, and lie about it.

>(This however is a great application for >2 mirrors and a write quorum
>of two, though.)
+1

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
