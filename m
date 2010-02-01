From: Luca Berra <bluca@comedia.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then
	disaster !!
Date: Mon, 1 Feb 2010 14:27:03 +0100
Message-ID: <20100201132703.GA29849@maude.comedia.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org> <4B65943A.4040800@shiftmail.org> <4B66B367.6030803@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B66B367.6030803@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 01, 2010 at 11:56:39AM +0100, Giovanni Tessore wrote:
> Yes, the new behaviour is good for raid-6.
> But unsafe for raid 1, 4, 5, 10.
> The old behaviour saved me in the past, and would have saved also this 
> time, allowing me to replace the disk as soon as possible.. the new one 
> didn't at all...
The 'new' behaviour was implemented because kicking drives out of an
array on a read error may prevent the array to be repaired at all.
modern drives _have_ correctable read errors, it is a fact.
So if md kicked drives on read error it is also possible to lose all
data on multiple failures (read errors on more than one drives, or
read-errors when sparing), that could have been recovered.

> The new one must at least clearly alert the user that a drive is getting 
> read errors on raid 1,4,5,10.
Agreed, now let's define 'clearly alert', besides syslog.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
