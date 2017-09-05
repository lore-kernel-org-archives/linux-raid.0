From: Phil Turmel <philip@turmel.org>
Subject: Re: [PATCH] md: allow changing set_name of running array
Date: Mon, 4 Sep 2017 23:06:29 -0400
Message-ID: <8a217462-fdc0-f011-8433-ed42986d4e75@turmel.org>
References: <429c2b1c84c44b0c09ea7aa8dfa86846885441f7.1504044125.git.mirq-linux@rere.qmqm.pl>
 <87tw0ne0xq.fsf@notabene.neil.brown.name>
 <20170901164110.y3op7umpgh4jvkr5@qmqm.qmqm.pl>
 <874lsjdwye.fsf@notabene.neil.brown.name>
 <20170904193639.iagu5d5iu3tdhce2@qmqm.qmqm.pl>
 <87pob6c62v.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87pob6c62v.fsf@notabene.neil.brown.name>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/04/2017 09:00 PM, NeilBrown wrote:
> If a name is given in mdadm.conf and it doesn't match the name in the
> metadata, that line will be ignored.  If mdadm doesn't find a match in
> mdadm.conf and the hostname doesn't match, the the array will be treated
> as "foreign" and will be assembled as e.g. /dev/md127 with a symlink
> from /dev/md/0_1.
> If the name and uuid in mdadm.conf do match the metadata, it will be
> treat as "local" and will be given the name that you would expect
> (/dev/md0, /dev/md/0).
> 
> So my guess is that the mdadm.conf you had at the time doesn't match
> what you have provided above.
> 
> It would be nice to add an option to "mdadm --incremental" to tell it to
> update various details like you can with "mdadm --assemble"....

I just delete the name and metadata version from mdadm.conf.  The above
would become:

ARRAY /dev/md/0 UUID=d5ea39a9:5ec27c36:c83296d4:70f879d4
ARRAY /dev/md/1 UUID=9bf69b92:2e7ba905:5f959c09:c8fecb99

The default output of mdadm -Es is overspecified for use as mdadm.conf,
though it works on precisely the setup that produced it.

Phil
