From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH] md: allow changing set_name of running array
Date: Mon, 4 Sep 2017 21:36:39 +0200
Message-ID: <20170904193639.iagu5d5iu3tdhce2@qmqm.qmqm.pl>
References: <429c2b1c84c44b0c09ea7aa8dfa86846885441f7.1504044125.git.mirq-linux@rere.qmqm.pl>
 <87tw0ne0xq.fsf@notabene.neil.brown.name>
 <20170901164110.y3op7umpgh4jvkr5@qmqm.qmqm.pl>
 <874lsjdwye.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874lsjdwye.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 04, 2017 at 12:22:33PM +1000, NeilBrown wrote:
> On Fri, Sep 01 2017, Micha³ Miros³aw wrote:
> 
> > On Fri, Sep 01, 2017 at 10:07:29AM +1000, NeilBrown wrote:
> >> On Wed, Aug 30 2017, Micha³ Miros³aw wrote:
> >> > Allow changing active array's set_name. This is the only way to
> >> > safely update superblock on an array which carries a mounted fs.
> >> 
> >> Do you really need to change the set_name of an active array?
> >> 
> >> The name is only used when the array is actived, so wait until the next
> >> time the array is stopped, and change the name then.
> >> 
> >> You can boot with a rescue CD or similar and use "--assemble
> >> --update=name", or with a bit of effort you could get the normal boot
> >> sequence to change the name.
> >> 
> >> I wouldn't object to adding something to mdadm so that it would read
> >> something from mdadm.conf, and update the set name at boot time.
> >> 
> >> What is the underlying problem that you are trying to solve here?
> >
> > I had to fix /dev/md* naming on a system with no physical access.
> >
> > The problem was that despite matching mdadm.conf entries, arrays started
> > with random 127-i indexes (because superblocks' set_names didn't match
> > hostname, I guess).
> 
> That's odd.  If an array is listed in mdadm.conf, that is enough to tell
> mdadm that it is "local" so that it doesn't need the hostname to match.
> Can you show me exactly what was in your mdadm.conf?

This is what was I had when it would reassign arrays on boot. System
hostname is 'rere' - it was renamed some time after creating arrays.

---8<---
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md/0  metadata=1.2 UUID=d5ea39a9:5ec27c36:c83296d4:70f879d4 name=rere2:0
ARRAY /dev/md/1  metadata=1.2 UUID=9bf69b92:2e7ba905:5f959c09:c8fecb99 name=rere2:1
---8<---

I don't have old versions of mdadm.conf, so had to recreate this one.
IIRC I verified UUIDs back then, but don't remember whether I modified
names or not. Thinking of it, how would mdadm behave if it had matching
UUIDs and mismatching array names in mdadm.conf?

Best Regards,
Micha³ Miros³aw
