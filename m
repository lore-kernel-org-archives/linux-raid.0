From: Adrian Bridgett <adrian@smop.co.uk>
Subject: growing RAID(1) without a resync
Date: Thu, 14 Jan 2010 19:29:53 +0000
Message-ID: <20100114192953.GC22267@ash.smop.co.uk>
Reply-To: adrian@smop.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've just resized my MD array at home and wondered if there is a way
to grow it without the long resync time - i.e. assuming it's clean.

I found this:
http://www.issociate.de/board/post/493770/Assume-clean_for_md_grow.html

Where Neil says that it's not (well, not without some deep hacking) -
I wondered if the status had changed.

I had a look for an MD "roadmap" just in case but couldn't see one :-)

Thanks,

Adrian
-- 
bitcube.co.uk - Expert Linux infrastructure consultancy
Puppet, Debian, Red Hat, Ubuntu, CentOS
