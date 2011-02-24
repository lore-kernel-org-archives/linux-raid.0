From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 14:49:35 -0600
Message-ID: <AANLkTind+KAHD1uhvfwJK-9MKTX0fw1RZS3L-QUiZkMc@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<4D5A7198.7060607@hardwarefreak.com>
	<ijdvmn$4ff$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijdvmn$4ff$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 15, 2011 at 7:39 AM, David Brown <david@westcontrol.com> wr=
ote:
> This brings up an important point - no matter what sort of system you=
 get
> (home made, mdadm raid, or whatever) you will want to do some tests a=
nd
> drills at replacing failed drives. =A0Also make sure everything is we=
ll
> documented, and well labelled. =A0When mdadm sends you an email telli=
ng you
> drive sdx has failed, you want to be /very/ sure you know which drive=
 is sdx
> before you take it out!

Agreed!  This will be a learn-as-I-go project.

> You also want to consider your raid setup carefully. =A0RAID 10 has b=
een
> mentioned here several times - it is often a good choice, but not
> necessarily. =A0RAID 10 gives you fast recovery, and can at best surv=
ive a
> loss of half your disks - but at worst a loss of two disks will bring=
 down
> the whole set. =A0It is also very inefficient in space. =A0If you use=
 SSDs, it
> may not be worth double the price to have RAID 10. =A0If you use hard=
 disks,
> it may not be sufficient safety.

And that's what has me thinking about cluster filesystems.
Ultimately, I'd like a pool of storage "nodes".  These could live on
the same physical machine, or be spread across multiple machines.  To
the clients, this pool of nodes would look like one single collection
of storage.  The benefit of this, in my opinion, is flexibility
(mainly easy to grow/add new nodes), but also a bit more safety.  If
one node dies, it doesn't take down the whole pool, just the files on
that node become unavailable.

Even better would be a "smart" pool, that, when a new node is added,
it automatically re-distributes all the files, so that the new node
has the same kind of space utilization as all the others.

> It is probably worth having a small array of SSDs (RAID1 or RAID10) t=
o hold
> the write intent bitmap, the journal for your main file system, and o=
f
> course your OS. =A0Maybe one of these absurdly fast PCI Express flash=
 disks
> would be a good choice.

Is that really necessary, though, when writes account for probably >5%
of total IO operations?  And (relatively speaking) write performance
is unimportant?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
