From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sat, 08 Jun 2013 22:08:14 -0500
Message-ID: <51B3F19E.3040805@hardwarefreak.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/8/2013 2:56 PM, Steve Bergman wrote:
> First of all, thank you to the people who took the time to help
> illuminate this issue.
> 
> To summarize... for unknown reasons, the 4 port SATA controller on the
> Dell PET-310 has an aggregate limitation of ~1.75 Gbit/s on the A&B
> and C&D port pairs. Each port can provide more than that to a single
> drive, but when trying to read or write both ports simultaneously,
> each port in the pair gets  ~0.87Gbit/s. (Which is probably some
> higher nominal value minus some overhead.)

This is almost certainly a result of forced IDE mode.  With this you end
up with a master/slave setup between the drives on each controller, and
all of the other overhead of EIDE.
 ____  _   _ ___ ____
/ ___|| \ | |_ _|  _ \
\___ \|  \| || || |_) |
 ___) | |\  || ||  __/
|____/|_| \_|___|_|   running down of XFS, showing desire for O_PONIES.

> Anyway, that's enough for me on this topic. Feel free to discuss among
> yourselves. But the back and forth on this could go on for weeks (if
> not more) and I don't care to allocate the time (delayed or not ;-)

When you drop a bomb like you have here, and run away, it simply tells
everyone that you're not willing to defend your claims and opinions.
Thus all of that typing was a waste of your time as it will be ignored.
 Given your misstatements of fact, about both XFS and EXT4, I can see
why you're running away.  I won't bother debunking all of it.  I will
simply say this.

If you'd learn to properly use fsync or O_DIRECT in your application
you'd have no problem with data/file integrity with XFS, EXT4, or any
filesystem.  Either puts the data on the platter right now.  You
apparently write all 2GB of your data to buffer cache and then issue a
sync.  That is *horrible* practice.  This *creates* a window of
opportunity for data loss.  And you're complaining about XFS delayed
allocation?

WRT your data security complaints about XFS, note that machines exist
today that move an aggregate 6-10GB/s to/from a single XFS filesystems.
 Try that with EXT.  Such performance isn't possible if one journals
data as you suggest all filesystems should.  If you need high
performance throughput from an application  *and* data security you use
parallel O_DIRECT.

-- 
Stan

