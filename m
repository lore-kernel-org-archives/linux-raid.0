From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH] md: allow changing set_name of running array
Date: Fri, 1 Sep 2017 18:41:10 +0200
Message-ID: <20170901164110.y3op7umpgh4jvkr5@qmqm.qmqm.pl>
References: <429c2b1c84c44b0c09ea7aa8dfa86846885441f7.1504044125.git.mirq-linux@rere.qmqm.pl>
 <87tw0ne0xq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87tw0ne0xq.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 01, 2017 at 10:07:29AM +1000, NeilBrown wrote:
> On Wed, Aug 30 2017, Micha³ Miros³aw wrote:
> > Allow changing active array's set_name. This is the only way to
> > safely update superblock on an array which carries a mounted fs.
> 
> Do you really need to change the set_name of an active array?
> 
> The name is only used when the array is actived, so wait until the next
> time the array is stopped, and change the name then.
> 
> You can boot with a rescue CD or similar and use "--assemble
> --update=name", or with a bit of effort you could get the normal boot
> sequence to change the name.
> 
> I wouldn't object to adding something to mdadm so that it would read
> something from mdadm.conf, and update the set name at boot time.
> 
> What is the underlying problem that you are trying to solve here?

I had to fix /dev/md* naming on a system with no physical access.

The problem was that despite matching mdadm.conf entries, arrays started
with random 127-i indexes (because superblocks' set_names didn't match
hostname, I guess).

Best Regards,
Micha³ Miros³aw
